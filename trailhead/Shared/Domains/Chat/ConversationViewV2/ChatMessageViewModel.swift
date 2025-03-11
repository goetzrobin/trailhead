//
//  ChatMessageStoreV2.swift
//  trailhead
//
//  Created by Robin Götz on 3/10/25.
//
import Foundation
import Observation
import SwiftUI

enum MessageState: Equatable {
    case stored                  // Message from server history
    case userSent                // User just sent it, looks normal
    case waitingForResponse      // Waiting for API to respond with AI message
    case streaming(String)       // Actively streaming content (with current text)
    case error(String)           // Something went wrong (with error message)
    case complete                // Done streaming
    
    var isWaiting: Bool {
        if case .waitingForResponse = self { return true }
        return false
    }
    
    var isStreaming: Bool {
        if case .streaming = self { return true }
        return false
    }
    
    var errorMessage: String? {
        if case .error(let msg) = self { return msg }
        return nil
    }
}

// SIMPLIFY: One message type for everything
struct ChatMessageV2: Identifiable, Equatable {
    let id: String
    let createdAt: Date
    let sender: MessageSender
    var content: String
    var state: MessageState
    
    enum MessageSender {
        case user
        case ai
    }
    
    // Add helper to update content during streaming
    mutating func appendContent(_ newContent: String) {
        if case .streaming = state {
            content += newContent
        }
    }
    
    // Helper to transition from streaming to complete
    mutating func completeStreaming() {
        if case .streaming = state {
            state = .complete
        }
    }
    
    // Helper to transition to error
    mutating func setError(_ message: String) {
        state = .error(message)
    }
}

// SIMPLIFY: One store with clear single source of truth
@Observable class ChatMessageViewModel {
    // MARK: - State
    private(set) var messages: [ChatMessageV2] = []
    
    var isLoadingExistingMessages: Bool {
        self.messageAPIClient.fetchMessagesStatus == .loading
    }
    
    // Track active stream
    private var streamTask: Task<Void, Never>?
    private var sessionLogId: UUID?
    
    // MARK: - Dependencies
    private let messageAPIClient: ChatMessageAPIClient
    
    init(messageAPIClient: ChatMessageAPIClient, sessionLogId: UUID? = nil) {
        self.messageAPIClient = messageAPIClient
        self.sessionLogId = sessionLogId
    }
    
    deinit {
        cancelStream()
    }
    
    
    // MARK: - Public Methods
    func fetchStoredMessages() {
        guard let sessionLogId = sessionLogId else { return }
        messageAPIClient.fetchStoredMessages(for: sessionLogId)
    }
    
    // Send user message
    func sendMessage(_ text: String) {
        print("[ConversationView2] user is trying to send a new message \(text.suffix(10))")
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        guard let sessionLogId = sessionLogId else {
            // Handle missing session
            return
        }
        
        // Add user message first
        let userMessage = ChatMessageV2(
            id: UUID().uuidString,
            createdAt: Date(),
            sender: .user,
            content: text,
            state: .userSent
        )
        messages.append(userMessage)
        
        // Add placeholder for AI response
        let aiMessage = ChatMessageV2(
            id: UUID().uuidString,
            createdAt: Date(),
            sender: .ai,
            content: "",
            state: .waitingForResponse
        )
        messages.append(aiMessage)
        
        // Start streaming
        streamResponse(userMessage: text, aiMessage: aiMessage, sessionLogId: sessionLogId)
    }
    
    // Cancel active stream
    func cancelStream() {
        streamTask?.cancel()
        streamTask = nil
        
        // Find any messages still streaming and mark as error
        for i in 0..<messages.count {
            if case .streaming = messages[i].state {
                messages[i].setError("Stream cancelled")
            } else if case .waitingForResponse = messages[i].state {
                messages[i].setError("Request cancelled")
            }
        }
    }
    
    func retry() {
        // Find last error message from AI
        if let index = messages.lastIndex(where: {
            $0.sender == .ai && ($0.state.errorMessage != nil)
        }) {
            // Get the previous user message to retry
            let lastUserMsgIndex = messages.lastIndex(where: { $0.sender == .user }) ?? -1
            
            if lastUserMsgIndex >= 0 {
                let userMessage = messages[lastUserMsgIndex]
                
                // Remove failed AI message
                messages.remove(at: index)
                
                // Create new AI message placeholder
                let newAiMessage = ChatMessageV2(
                    id: UUID().uuidString,
                    createdAt: Date(),
                    sender: .ai,
                    content: "",
                    state: .waitingForResponse
                )
                messages.append(newAiMessage)
                
                // Retry stream
                guard let sessionLogId = sessionLogId else { return }
                streamResponse(userMessage: userMessage.content, aiMessage: newAiMessage, sessionLogId: sessionLogId)
            }
        }
    }
    
    // MARK: - Private Streaming Implementation
    
    private func streamResponse(userMessage: String, aiMessage: ChatMessageV2, sessionLogId: UUID) {
        // Find index for this AI message
        guard let msgIndex = messages.firstIndex(where: { $0.id == aiMessage.id }) else {
            return
        }
        
        // Update state to show we're streaming
        streamTask = Task {
            do {
                print("We are starting our stream")
                // Start streaming - get index again to ensure freshness
                self.messages[msgIndex].state = .streaming("")
      
                
                print("We are streaming this bisshhhhhh")
                
//                // Connect to stream
//                for try await chunk in try await apiClient.streamResponse(
//                    message: userMessage,
//                    sessionLogId: sessionLogId
//                ) {
//                    // Process each chunk
//                    await MainActor.run {
//                        // Find message index again to handle array changes
//                        if let idx = self.messages.firstIndex(where: { $0.id == aiMessage.id }) {
//                            // Append content and update streaming state with new text
//                            self.messages[idx].appendContent(chunk.textDelta ?? "")
//                            self.messages[idx].state = .streaming(self.messages[idx].content)
//                        }
//                    }
//                }
                
                // Streaming complete
                await MainActor.run {
                    print("We completed our stream")
                        self.messages[msgIndex].completeStreaming()
                }
            } catch {
                await MainActor.run {
                    print("We errored during our stream")
                    if let idx = self.messages.firstIndex(where: { $0.id == aiMessage.id }) {
                        self.messages[idx].setError(error.localizedDescription)
                    }
                }
            }
        }
    }
}
