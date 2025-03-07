//
//  ChatMessageStore.swift
//  trailhead
//
//  Created by Robin Götz on 2/6/25.
import Foundation
import Observation
import SwiftUI

// MARK: - View Models

struct MessageViewModel {
    let message: ChatMessage
    let streamState: MessageStreamState

    var id: String { message.id }
    var content: String { message.content }
    var type: ChatMessageType { message.type }
}

enum MessageStreamState {
    case stored
    case streaming(StreamState)
}

// MARK: - Stream State - Small enums good!
enum StreamState: Equatable {
    case idle
    case starting
    case streaming
    case error(String)
    case done

    var isPreparingToStream: Bool {
        switch self {
        case .starting:
            return true
        default:
            return false
        }
    }
    
    var isActivelyStreaming: Bool {
        switch self {
        case .streaming:
            return true
        default:
            return false
        }
    }
    
    var isInProgress: Bool {
        switch self {
        case .starting, .streaming:
            return true
        default:
            return false
        }
    }
    
    var description: String {
        switch self {
        case .idle: return "idle"
        case .starting: return "starting"
        case .streaming: return "streaming"
        case .error(let message): return "error: \(message)"
        case .done: return "done"
        }
    }
}

// MARK: - Store

@Observable class ChatMessageStore {
    // MARK: - State - Keep grouped at top
    private(set) var streamingMessages: [StreamingMessage] = []
    private(set) var streamState: StreamState = .idle
    private var sessionLogId: UUID?
    
    // MARK: - Stream Control
    private var streamTask: Task<Void, Never>?

    // MARK: - Dependencies
    private let sessionApiClient: SessionAPIClient
    private let authProvider: AuthorizationProvider
    private let messageApiClient: ChatMessageAPIClient
    private let throttler: StreamThrottler
    private let slug: String
    private let userId: UUID

    // MARK: - Public Properties - Keep grouped for easy scan
    
    var storedMessages: [StoredMessage] {
        self.messageApiClient.fetchMessagesStatus.data ?? []
    }
    
    var isLoadingStoredMessages: Bool {
        self.messageApiClient.fetchMessagesStatus == .loading
    }
   
    var messages: [MessageViewModel] {
        // Stored messages from API
        let stored = storedMessages.map {
            MessageViewModel(
                message: $0,
                streamState: .stored
            )
        }

        // Local streaming messages
        let streaming = streamingMessages.map {
            MessageViewModel(
                message: $0,
                streamState: .streaming(streamState)
            )
        }

        // Sort by creation time
        return (stored + streaming).sorted {
            $0.message.createdAt < $1.message.createdAt
        }
    }

    var isPreparingMessageStream: Bool {
        streamState.isPreparingToStream
    }

    var errorMessage: String? {
        if case .error(let message) = streamState {
            return message
        }
        return nil
    }
    
    var startSessionStatus: ResponseStatus<SessionLog> {
        self.sessionApiClient.startSessionStatus
    }
    
    var endSessionStatus: ResponseStatus<SessionLog> {
        self.sessionApiClient.endSessionStatus
    }

    // MARK: - Initialization

    init(
        sessionApiClient: SessionAPIClient,
        authProvider: AuthorizationProvider,
        userId: UUID,
        slug: String,
        sessionLogId: UUID?,
        throttler: StreamThrottler = StreamThrottler()
    ) {
        print("[CHAT_STORE] Initializing with userId: \(userId), sessionLogId: \(String(describing: sessionLogId))")
        
        self.sessionApiClient = sessionApiClient
        self.authProvider = authProvider
        self.throttler = throttler
        self.userId = userId
        self.sessionLogId = sessionLogId
        self.slug = slug

        let apiClient = ChatMessageAPIClient(authProvider: authProvider)
        self.messageApiClient = apiClient

        Task {
            print("[CHAT_STORE] Setting up throttler callback")
            await throttler.setCallback { [weak self] chunk in
                self?.handleChunk(chunk)
            }
        }
    }
    
    deinit {
        print("[CHAT_STORE] Deinitializing and cancelling any active streams")
        cancelStream()
    }

    // MARK: - Message Loading
    
    func loadInitialMessages() {
        Task {
            guard let sessionLogId = self.sessionLogId else {
                print("[CHAT_STORE] No session log id, can't load initial messages")
                return
            }
            
            print("[CHAT_STORE] Loading initial messages for session: \(sessionLogId)")
            self.messageApiClient.fetchStoredMessages(for: sessionLogId)
            streamingMessages = []  // Clear any streaming messages on reload
        }
    }

    // MARK: - Session Management
    
    func startSession(
        with scores: SessionScores,
        onSuccess: ((_: SessionLog) -> Void)?
    ) {
        print("[CHAT_STORE] Starting session with slug: \(slug)")
        self.messageApiClient.fetchMessagesStatus = .loading
        
        self.sessionApiClient.startSession(with: slug, for: userId, scores: scores) { newSessionLog in
            print("[CHAT_STORE] Session started successfully with id: \(newSessionLog.id)")
            self.sessionLogId = newSessionLog.id
            self.messageApiClient.fetchMessagesStatus = .success([])
            onSuccess?(newSessionLog)
        }
    }
    
    func endSession(
        with scores: SessionScores,
        onSuccess: ((_: SessionLog) -> Void)?
    ) {
        guard let sessionLogId = self.sessionLogId else {
            print("[CHAT_STORE] No session log id, can't end session")
            return
        }
        
        print("[CHAT_STORE] Ending session: \(sessionLogId)")
        self.sessionApiClient.endSession(ofLogWithId: sessionLogId, scores: scores) { endedSessionLog in
            print("[CHAT_STORE] Session ended successfully")
            onSuccess?(endedSessionLog)
        }
    }
    
    func refreshSessionsAndLogs() {
        print("[CHAT_STORE] Refreshing all sessions for user: \(userId)")
        self.sessionApiClient.fetchSessionsWithLogs(for: userId)
    }

    // MARK: - Message Handling
    
    func sendMessage(
        with inputText: String,
        type: String = "user-message",
        scope: String = "external",
        onStreamStart: (() -> Void)? = nil
    ) async {
        // Clean input first
        let sanitizedInput = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validate input
        guard !sanitizedInput.isEmpty else {
            print("[CHAT_STORE] Empty message, not sending")
            return
        }
        
        print("[CHAT_STORE] Sending message type: \(type), length: \(sanitizedInput.count)")

        // If user message, create a temporary message right away for UI responsiveness
        if ChatMessageType(rawValue: type) == .userMessage {
            let tempId = UUID().uuidString
            print("[CHAT_STORE] Creating temporary user message with id: \(tempId)")
            
            let userMessage = StreamingMessage.createForUser(
                id: tempId,
                content: sanitizedInput,
                scope: ChatMessageScope(rawValue: scope) ?? .external
            )
            streamingMessages.append(userMessage)
        }

        // Start streaming process
        await startStreaming(
            userId: userId,
            message: sanitizedInput,
            slug: slug,
            type: type,
            scope: scope,
            onStreamStart: onStreamStart ?? {})
    }
    
    func haveSamReachOut(onStreamStart: (() -> Void)? = nil) async {
        // Check if already streaming
        if streamState.isInProgress {
            print("[CHAT_STORE] Already streaming, not starting Sam reach out")
            return
        }
        
        print("[CHAT_STORE] Having Sam reach out with internal message")
        await self.sendMessage(
            with: "The user has started the conversation",
            type: "ai-message",
            scope: "internal"
        )
    }

    func retryOnError() async {
        // If error occurred, get last message and retry
        if let erroredMessage = self.streamingMessages.last {
            print("[CHAT_STORE] Retrying after error with message: \(erroredMessage.id)")
            self.streamingMessages.removeLast()
            
            await self.sendMessage(
                with: "An error occured. Let's try to reach out again. The last thing the user was meant to see was: \(erroredMessage.content)",
                type: "ai-message",
                scope: "internal"
            )
        } else {
            print("[CHAT_STORE] No errored message found to retry")
        }
    }
    
    func cancelStream() {
        print("[CHAT_STORE] Cancelling active stream")
        streamTask?.cancel()
        cleanup()
    }

    // MARK: - Private Stream Handling
    
    private func startStreaming(
        userId: UUID,
        message: String,
        slug: String,
        type: String = "user-message",
        scope: String = "external",
        onStreamStart: @escaping () -> Void
    ) async {
        print("[STREAM] Starting with message type: \(type), preview: \(message.prefix(20))...")
        streamState = .starting

        streamTask = Task {
            do {
                print("[STREAM] Connecting to stream...")
                
                for try await event in try await self.messageApiClient.streamResponse(
                    message: message, messageType: type, scope: scope,
                    userId: userId, slug: slug)
                {
                    print("[STREAM] Received event data")
                    streamState = .streaming

                    try await handleStreamEvent(event, onStreamStart: onStreamStart)
                }
            } catch {
                print("[STREAM ERROR] \(error.localizedDescription)")
                await MainActor.run {
                    streamState = .error(error.localizedDescription)
                    cleanup()
                }
            }
        }

        await streamTask?.value
    }

    private func handleStreamEvent(_ data: String, onStreamStart: () -> Void) async throws {
        print("[EVENT] Processing event data: \(data.prefix(40))...")
        let events = ChatMessageAPIClient.parseStreamEvents(data)
        
        for event in events {
            switch event {
            case .start:
                print("[EVENT] Stream start event, triggering callback")
                await MainActor.run {
                    onStreamStart()
                }
                
            case .chunk(let chunk):
                print("[CHUNK] Received id: \(chunk.id), content length: \(chunk.textDelta?.count ?? 0)")
                await throttler.enqueueChunk(chunk)
                
            case .done:
                print("[EVENT] Stream complete")
                await MainActor.run {
                    streamState = .done
                    cleanup()
                }
                
            case .error(let error):
                print("[EVENT ERROR] \(error.localizedDescription)")
                await MainActor.run {
                    streamState = .error(error.localizedDescription)
                    cleanup()
                }
            }
        }
    }

    private func handleChunk(_ chunk: ChatMessageChunk) {
        // Try to find existing message for this run
        if let index = streamingMessages.firstIndex(where: { $0.runId == chunk.runId }) {
            // Update existing message
            print("[MESSAGE] Updating message \(chunk.runId.prefix(8)) with new chunk")
            var message = streamingMessages[index]
            message.appendChunk(chunk)
            streamingMessages[index] = message
        } else if chunk.type == .aiMessage {
            // Create new AI message
            print("[MESSAGE] Creating new message for chunk: \(chunk.id)")
            var message = StreamingMessage.createForAI(
                llmInteractionId: chunk.id,
                runId: chunk.runId
            )
            message.appendChunk(chunk)
            streamingMessages.append(message)
        } else {
            print("[MESSAGE] Received chunk with unhandled type: \(String(describing: chunk.type))")
        }
    }

    private func cleanup() {
        print("[STREAM] Cleaning up resources, state was: \(streamState.description)")
        streamTask?.cancel()
        streamTask = nil
        streamState = .idle
    }
}
