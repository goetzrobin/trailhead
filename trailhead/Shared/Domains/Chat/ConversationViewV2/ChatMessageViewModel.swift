//
//  ChatMessageStoreV2.swift
//  trailhead
//
//  Created by Robin Götz on 3/10/25.
//
import Foundation
import Observation
import SwiftUI

struct MessagePair: Identifiable {
    let id: String
    let timestamp: Date
    let userMessage: String?
    var aiMessage: String?
    var streamState: StreamState
    var chunks: [ChatMessageChunk]?
    var isUserMessageInternal: Bool
    
    enum StreamState {
        case isWaitingForStreamToStart
        case streaming
        case complete
        case error(String)
        case stored
    }
    
    // Helpers to identify pair type
    var isUserOnly: Bool {
        return userMessage != nil && aiMessage == nil
    }
    
    var isAiOnly: Bool {
        return userMessage == nil && aiMessage != nil
    }
    
    var isPair: Bool {
        return userMessage != nil && aiMessage != nil
    }
    
    var isStreaming: Bool {
        if case .streaming = streamState { return true }
        return false
    }
    
    var isComplete: Bool {
        if case .complete = streamState { return true}
        return false
    }
    
    var isWaitingForStreamToStart: Bool {
        if case .isWaitingForStreamToStart = streamState { return true}
        return false
    }
    
    var isError: Bool {
        if case .error = streamState { return true}
        if let chunks = chunks {
            return chunks.firstIndex(where: {$0.chunkType == "error"}) ?? -1 > -1
        }
        return false
    }
    
    func withNewId(_ newId: String) -> MessagePair {
          return MessagePair(
              id: newId,
              timestamp: self.timestamp,
              userMessage: self.userMessage,
              aiMessage: self.aiMessage,
              streamState: self.streamState,
              chunks: self.chunks,
              isUserMessageInternal: self.isUserMessageInternal
          )
      }
    
    func withNewChunks(_ chunks: [ChatMessageChunk]) -> MessagePair {
        return MessagePair(
            id: self.id,
            timestamp: self.timestamp,
            userMessage: self.userMessage,
            aiMessage: chunks.compactMap {$0.textDelta ?? ""}.joined(),
            streamState: self.streamState,
            chunks: chunks,
            isUserMessageInternal: self.isUserMessageInternal
        )
    }
}

@Observable class ChatMessageViewModel {
    private(set) var messagePairs: [MessagePair] = []
    private var activeStreamTask: Task<Void, Never>?
    private var activeChunks: [String: [ChatMessageChunk]] = [:]
    
    var isLoadingExistingMessages: Bool {
        self.messageAPIClient.fetchMessagesStatus == .loading
    }
    
    // MARK: - Dependencies
    private let messageAPIClient: ChatMessageAPIClient
    private let userId: UUID
    private let slug: String
    
    init(messageAPIClient: ChatMessageAPIClient, userId: UUID, slug: String) {
        self.messageAPIClient = messageAPIClient
        self.userId = userId
        self.slug = slug
        print("[ChatViewModel] Initialized for user \(userId) - slug \(slug)")
    }
    
    deinit {
        print("[ChatViewModel] Deinitializing, canceling streams")
        cancelActiveStreams()
    }
    
    // MARK: - Message Management
    func haveSamReachOut() {
        self.sendMessage("The user has initiated the conversation! Time to welcome them!", type: "ai-message", scope: "internal")
    }
    
    func sendMessage(_ text: String,
                     type: String = "user-message",
                     scope: String = "external"
    ) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            print("[ChatViewModel] Ignored empty message")
            return
        }
        
        print("[ChatViewModel] Sending: \(trimmedText.prefix(20))")
        
        // Create a unique runId for this interaction
        let runId = UUID().uuidString
        
        // Create initial message pair
        let pair = MessagePair(
            id: runId,
            timestamp: Date(),
            userMessage: trimmedText,
            aiMessage: "",
            streamState: .isWaitingForStreamToStart,
            chunks: [],
            isUserMessageInternal: scope == "internal"
        )
        
        print("[ChatViewModel] Created pair with id: \(pair.id)")
        
        // Add to beginning of the list
        messagePairs.insert(pair, at: 0)
        activeChunks[runId] = []
        
        // Start streaming response
        streamResponse(runId: runId, userMessage: trimmedText, slug: self.slug, type: type, scope: scope)
    }
    
    private func streamResponse(
        runId: String,
        userMessage: String,
        slug: String,
        type: String = "user-message",
        scope: String = "external"
    ) {
        print("[ChatViewModel] Starting stream for pair of run: \(runId)")
        
        activeStreamTask = Task {
            do {
                print("[ChatViewModel] Connected to stream API")
                let streamState = StreamState(initialRunId: runId)
                
                // Connect to stream API
                for try await data in try await messageAPIClient.streamResponse(
                    message: userMessage,
                    messageType: type,
                    scope: scope,
                    userId: self.userId,
                    slug: slug) {
                    
                    print("[EVENT] Processing event data: \(data.prefix(40))...")
                    let events = ChatMessageAPIClient.parseStreamEvents(data)
                    
                    for event in events {
                        await handleStreamEvent(
                            event: event,
                            streamState: streamState
                        )
                    }
                }
            } catch {
                await handleStreamError(error: error, runId: runId)
            }
        }
    }

    // Helper class to track stream state
    private class StreamState {
        var runId: String
        var chunkCount: Int = 0
        
        init(initialRunId: String) {
            self.runId = initialRunId
        }
    }

    // Handle individual stream events
    private func handleStreamEvent(
        event: StreamEvent,
        streamState: StreamState
    ) async {
        switch event {
        case .start:
            await handleStreamStart(runId: streamState.runId)
            
        case .chunk(let chunk):
            await handleStreamChunk(
                chunk: chunk,
                streamState: streamState
            )
            
        case .done:
            await handleStreamDone(
                streamState: streamState
            )
            
        case .error(let error):
            print("[EVENT ERROR] \(error.localizedDescription)")
            await handleStreamError(error: error, runId: streamState.runId)
        }
    }

    // Handle stream start event
    private func handleStreamStart(runId: String) async {
        await MainActor.run {
            print("[EVENT] Stream start event, marking pair \(runId) as streaming")
            if let index = messagePairs.firstIndex(where: { $0.id == runId }) {
                messagePairs[index].streamState = .streaming
            }
        }
    }

    // Handle stream chunk event
    private func handleStreamChunk(
        chunk: ChatMessageChunk,
        streamState: StreamState
    ) async {
        print("[CHUNK] Received id: \(chunk.id), content length: \(chunk.textDelta?.count ?? 0)")
        streamState.chunkCount += 1
        
        if chunk.chunkType == "error" {
            print("[ChatViewModel] Error chunk: \(chunk)")
        }
        
//        if streamState.chunkCount % 10 == 0 {
            print("[ChatViewModel] Received \(streamState.chunkCount) chunks for \(streamState.runId)")
//        }
        
        await MainActor.run {
            // Check if first chunk and update runId if needed
            if streamState.chunkCount == 1 {
                handleFirstChunk(chunk: chunk, streamState: streamState)
            }
            
            // Store chunk with updated runId
            activeChunks[streamState.runId, default: []].append(chunk)
            
            // Update message pair
            updateMessagePair(chunk: chunk, streamState: streamState)
        }
    }

    // Special handling for first chunk to update IDs
    private func handleFirstChunk(chunk: ChatMessageChunk, streamState: StreamState) {
        let oldId = streamState.runId
        print("[ChatViewModel] First chunk received, server ID: \(chunk.id)")
        
        // Find message pair with temporary ID
        if let index = messagePairs.firstIndex(where: { $0.id == oldId }) {
            // Update the ID to match server's ID
            messagePairs[index] = messagePairs[index].withNewId(chunk.id)
            print("[ChatViewModel] Updated message pair ID from \(oldId) to \(chunk.id)")
            
            // Move any existing chunks to new ID
            if let existingChunks = activeChunks[oldId] {
                activeChunks[chunk.id] = existingChunks
                activeChunks.removeValue(forKey: oldId)
            }
            
            // Update streamState to use new ID
            streamState.runId = chunk.id
        }
    }

    // Update message pair with current chunks
    private func updateMessagePair(chunk: ChatMessageChunk, streamState: StreamState) {
        guard let index = messagePairs.firstIndex(where: { $0.id == streamState.runId }) else {
            print("[ChatViewModel] Could not find pair: \(streamState.runId)")
            return
        }
        
        if let chunks = activeChunks[streamState.runId] {
            messagePairs[index] = messagePairs[index].withNewChunks(chunks)
        }
    }

    // Handle stream done event
    private func handleStreamDone(
        streamState: StreamState
    ) async {
        await MainActor.run {
            print("[ChatViewModel] Stream complete for \(streamState.runId) - \(streamState.chunkCount) chunks")
            
            if let index = messagePairs.firstIndex(where: { $0.id == streamState.runId }),
               let chunks = activeChunks[streamState.runId] {
                messagePairs[index].streamState = .complete
                print("[ChatViewModel] Final message length: \(messagePairs[index].aiMessage?.count ?? 0)")
            }
        }
    }

    // Handle stream error
    private func handleStreamError(error: Error, runId: String) async {
        await MainActor.run {
            print("[ChatViewModel] Stream error: \(error.localizedDescription)")
            
            if let index = messagePairs.firstIndex(where: { $0.id == runId }) {
                messagePairs[index].streamState = .error(error.localizedDescription)
            }
        }
    }
    
    func cancelActiveStreams() {
        print("[ChatViewModel] Canceling all streams")
        activeStreamTask?.cancel()
        activeStreamTask = nil
        
        // Find any streaming messages and mark them as error
        for i in 0..<messagePairs.count {
            if case .streaming = messagePairs[i].streamState {
                print("[ChatViewModel] Marking streaming message \(messagePairs[i].id) as canceled")
                messagePairs[i].streamState = .error("Stream canceled")
            }
        }
    }
    
    func retry(index: Int) {
        print("[ChatViewModel] Attempting retry")
     
        let errorPair = messagePairs[index]
        print(
            "[ChatViewModel] Found error at index \(index), id: \(errorPair.id)"
        )
            
        // Need user message to retry
        guard let userMessage = errorPair.userMessage else {
            print("[ChatViewModel] Cannot retry: missing message or session")
            return
        }
            
        // Remove error message
        messagePairs.remove(at: index)
        
        if index == 0 {
            // first message is sam reaching out
            sendMessage(userMessage, type: "ai-message", scope: "internal")
        } else {
            // Send again
            sendMessage(userMessage)
        }
    }

    // Load stored messages
    func fetchStoredMessages(for sessionLogId: UUID?) {
        guard let sessionLogId = sessionLogId else {
            print("[ChatViewModel] Cannot load: missing sessionLogId")
            return
        }
        
        print("[ChatViewModel] Loading for sessionLogId \(sessionLogId)")
            do {
                print("[ChatViewModel] Fetching from API")
                try messageAPIClient.fetchStoredMessages(for: sessionLogId) { storedMessages in
                print("[ChatViewModel] Got \(storedMessages.count) messages")
                
                let pairs = MessageAdapter.createMessagePairsFromStored(messages: storedMessages)
                print("[ChatViewModel] Created \(pairs.count) pairs")
                
                    Task {
                        await MainActor.run {
                            // Add to end (newest messages at beginning)
                            self.messagePairs.append(contentsOf: pairs)
                            print("[ChatViewModel] Total pairs now: \(self.messagePairs.count)")
                        }
                    }
                }
            } catch {
                print("[ChatViewModel] Failed to load: \(error.localizedDescription)")
            }
      
    }
}

struct MessageAdapter {
    // Convert streaming chunks to UI model
    static func createMessagePairFromChunks(userMessage: String, chunks: [ChatMessageChunk]) -> MessagePair {
        print("[MessageAdapter] Creating pair from \(chunks.count) chunks")
        
        // Extract AI content from chunks
        let aiContent = chunks.compactMap { $0.textDelta }.joined()
        
        // Determine state
        let state: MessagePair.StreamState
        if chunks.contains(where: { $0.chunkType == "error" }) {
            let errorMsg = chunks.first(where: { $0.chunkType == "error" })?.response?["message"] ?? "Unknown error"
            print("[MessageAdapter] Error state: \(errorMsg)")
            state = .error(errorMsg)
        } else if chunks.last?.finishReason != nil {
            print("[MessageAdapter] Complete state")
            state = .complete
        } else {
            print("[MessageAdapter] Streaming state")
            state = .streaming
        }
        
        // Create message pair
        return MessagePair(
            id: UUID().uuidString,
            timestamp: chunks.first?.createdAt ?? Date(),
            userMessage: userMessage,
            aiMessage: aiContent,
            streamState: state,
            chunks: chunks,
            isUserMessageInternal: false
        )
    }
    
    // Convert stored messages to UI model
    static func createMessagePairsFromStored(messages: [StoredMessage]) -> [MessagePair] {
        print("[MessageAdapter] Creating from \(messages.count) stored messages")
        
        // Group by runId
        let groupedByRun = Dictionary(grouping: messages) { $0.id }
        print("[MessageAdapter] Grouped into \(groupedByRun.count) conversations")
        
        let pairs = groupedByRun.compactMap { (runId, messagesInRun) -> MessagePair? in
            // Find user message
            let userMsg = messagesInRun.first(where: { $0.type == .userMessage })
            
            // Find AI response
            let aiMsg = messagesInRun.first(where: { $0.type == .aiMessage })
            
            // Skip if both nil
            if userMsg == nil && aiMsg == nil {
                print("[MessageAdapter] Skipping runId: \(runId) - no messages")
                return nil
            }
            
            print("[MessageAdapter] Creating stored pair, hasUser: \(userMsg != nil), hasAI: \(aiMsg != nil)")
            
            return MessagePair(
                id: UUID().uuidString,
                timestamp: (userMsg ?? aiMsg)!.createdAt,
                userMessage: userMsg?.content,
                aiMessage: aiMsg?.content,
                streamState: .stored,
                chunks: nil,
                isUserMessageInternal: false
            )
        }
        
        print("[MessageAdapter] Created \(pairs.count) pairs")
        return pairs
    }
    
    // Create AI-only message
    static func createAiOnlyPair(message: String) -> MessagePair {
        print("[MessageAdapter] Creating AI-only pair")
        return MessagePair(
            id: UUID().uuidString,
            timestamp: Date(),
            userMessage: nil,
            aiMessage: message,
            streamState: .complete,
            chunks: nil,
            isUserMessageInternal: false
        )
    }
}
