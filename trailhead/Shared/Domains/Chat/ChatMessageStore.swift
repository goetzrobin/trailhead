//
//  ChatMessageStore.swift
//  trailhead
//
//  Created by Robin Götz on 2/6/25.
//
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

// MARK: - Store

@Observable class ChatMessageStore {
    // MARK: - State
    var storedMessages: [StoredMessage] {
        self.messageApiClient.fetchMessagesStatus.data ?? []
    }
    private(set) var streamingMessages: [StreamingMessage] = []
    private(set) var streamState: StreamState = .idle

    // MARK: - Dependencies
    private let sessionApiClient: SessionAPIClient
    private let authProvider: AuthorizationProvider
    private let messageApiClient: ChatMessageAPIClient
    private let throttler: StreamThrottler

    private let slug: String
    private let userId: UUID
    
    private var sessionLogId: UUID?

    // MARK: - Stream Control
    private var streamTask: Task<Void, Never>?

    var isLoadingStoredMessages: Bool {
        self.messageApiClient.fetchMessagesStatus == .loading
    }
   
    var messages: [MessageViewModel] {
        let stored = storedMessages.map {
            MessageViewModel(
                message: $0,
                streamState: .stored
            )
        }

        let streaming = streamingMessages.map {
            MessageViewModel(
                message: $0,
                streamState: .streaming(.idle)
            )
        }

        return (stored + streaming).sorted {
            $0.message.createdAt < $1.message.createdAt
        }
    }

    var isStreaming: Bool { streamState.isStarting }

    var errorMessage: String? {
        if case .error(let message) = streamState {
            return message
        }
        return nil
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
        self.sessionApiClient = sessionApiClient
        self.authProvider = authProvider
        self.throttler = throttler

        self.userId = userId
        self.sessionLogId = sessionLogId
        self.slug = slug

        let apiClient = ChatMessageAPIClient(authProvider: authProvider)
        self.messageApiClient = apiClient

        Task {
            await throttler.setCallback { [weak self] chunk in
                self?.handleChunk(chunk)
            }
        }
    }

    func loadInitialMessages() {
        Task {
            guard let sessionLogId = self.sessionLogId else {
                print(
                    "No session log id passed in, unable to load initial messages"
                )
                return
            }
            self.messageApiClient.fetchStoredMessages(for: sessionLogId)
            streamingMessages = []  // Clear any streaming messages on reload
        }
    }
    
    func startSession(
        with scores: SessionScores,
        onSuccess: ((_: SessionLog) -> Void)?
    ) {
        self.messageApiClient.fetchMessagesStatus = .loading
        self.sessionApiClient
            .startSession(with: slug, for: userId, scores: scores) {
                newSessionLog in
                print("new session log with id \(newSessionLog.id)")
                self.sessionLogId = newSessionLog.id
                self.messageApiClient.fetchMessagesStatus = .success([])
                onSuccess?(newSessionLog)
            }
    }
    
    var endSessionStatus: ResponseStatus<SessionLog> {
        self.sessionApiClient.endSessionStatus
    }
    func endSession(
        with scores: SessionScores,
        onSuccess: ((_: SessionLog) -> Void)?
    ) {
        guard let sessionLogId = self.sessionLogId else {
            print("no session log id, cant end session")
            return
        }
        self.sessionApiClient
            .endSession(ofLogWithId: sessionLogId, scores: scores) {
                endedSessionLog in
                onSuccess?(endedSessionLog)
            }
    }
    
    func refreshSessionsAndLogs() {
        self.sessionApiClient.fetchSessionsWithLogs(for: userId)
    }

    // MARK: - Message Handling
    func sendMessage(
        with inputText: String,
        type: String = "user-message",
        scope: String = "external",
        onStreamStart: (() -> Void)? = nil
    )
    async
    {
        let sanitizedInput = inputText.trimmingCharacters(
            in: .whitespacesAndNewlines)
        guard !sanitizedInput.isEmpty
        else {
            print(
                "some arguments missing: \(sanitizedInput), \(String(describing: userId)), \(String(describing: slug))")
            return
        }

        if ChatMessageType(rawValue: type) == .userMessage {
            // Create temporary user message
            let tempId = UUID().uuidString
            let userMessage = StreamingMessage.createForUser(
                id: tempId,
                content: sanitizedInput,
                scope: ChatMessageScope(rawValue: scope) ?? .external
            )
            streamingMessages.append(userMessage)
        }

        await startStreaming(
            userId: userId,
            message: sanitizedInput,
            slug: slug,
            type: type,
            scope: scope,
            onStreamStart: onStreamStart ?? {})
    }
    
    func haveSamReachOut(onStreamStart: (() -> Void)? = nil
    ) async {
        await self.sendMessage(with: "The user has started the conversation",
                               type: "ai-message",
                               scope: "internal")
    }

    func retryOnError() async {
        if let erroredMessage = self.streamingMessages.last {
            print("\(erroredMessage)")
            self.streamingMessages.removeLast()
            await self.sendMessage(with: "An error occured. Let's try to reach out again. The last thing the user was meant to see was: \(erroredMessage.content)",
                                   type: "ai-message",
                                   scope: "internal")
        }
    }

    private func startStreaming(
        userId: UUID,
        message: String,
        slug: String,
        type: String = "user-message",
        scope: String = "external",
        onStreamStart: @escaping () -> Void
    ) async {
        streamState = .starting

        streamTask = Task {
            do {
                for try await event in try await self.messageApiClient
                    .streamResponse(
                        message: message, messageType: type, scope: scope,
                        userId: userId, slug: slug)
                {
                    streamState = .streaming

                    try await handleStreamEvent(
                        event, onStreamStart: onStreamStart)
                }
            } catch {
                print(error)
                await MainActor.run {
                    streamState = .error(error.localizedDescription)
                    cleanup()
                }
            }
        }

        await streamTask?.value
    }

    private func handleStreamEvent(_ data: String, onStreamStart: () -> Void) async throws {
        let events = ChatMessageAPIClient.parseStreamEvents(data)
        
        for event in events {
            
            switch event {
            case .start:
                await MainActor.run {
                    onStreamStart()
                }
                
            case .chunk(let chunk):
                await throttler.enqueueChunk(chunk)
                
            case .done:
                await MainActor.run {
                    streamState = .done
                    cleanup()
                }
                
            case .error(let error):
                await MainActor.run {
                    streamState = .error(error.localizedDescription)
                    cleanup()
                }
            }
        }
    }

    private func handleChunk(_ chunk: ChatMessageChunk) {
        // Find or create streaming message for this chunk
        if let index = streamingMessages.firstIndex(where: {
            $0.runId == chunk.runId
        }) {
            // Update existing message
            var message = streamingMessages[index]
            message.appendChunk(chunk)
            streamingMessages[index] = message
        } else if chunk.type == .aiMessage {
            // Create new AI message
            var message = StreamingMessage.createForAI(
                llmInteractionId: chunk.id,
                runId: chunk.runId
            )
            message.appendChunk(chunk)
            streamingMessages.append(message)
        }
    }

    private func cleanup() {
        streamTask?.cancel()
        streamTask = nil
        streamState = .idle
    }

    func cancelStream() {
        streamTask?.cancel()
        cleanup()
        streamState = .idle
    }

    deinit {
        cancelStream()
    }
}

// MARK: - Stream State
enum StreamState {
    case idle
    case starting
    case streaming
    case error(String)
    case done

    var isStarting: Bool {
        switch self {
        case .starting:
            return true
        default:
            return false
        }
    }
}
