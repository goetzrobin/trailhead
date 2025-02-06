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
    var type: BaseMessageType { message.type }
}

enum MessageStreamState {
    case stored
    case streaming(ThinkingState)

    struct ThinkingState {
        let isThinking: Bool
        let elapsedTime: TimeInterval?
        let thinkingTime: TimeInterval?
    }
}

// MARK: - Store

@Observable class ChatMessageStore {
    // MARK: - State
    private var storedMessages: [StoredMessage] = []
    private var streamingMessages: [StreamingMessage] = []
    private var streamState: StreamState = .idle

    // MARK: - Dependencies
    private let apiClient: ChatMessageAPIClient
    private let thinkingState: ThinkingStateStore
    private let throttler: StreamThrottler

    // MARK: - Stream Control
    private var streamTask: Task<Void, Never>?

    // MARK: - Public Interface

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
                streamState: .streaming(
                    MessageStreamState.ThinkingState(
                        isThinking: thinkingState.isThinking,
                        elapsedTime: thinkingState.elapsedTime,
                        thinkingTime: thinkingState.thinkingTime
                    ))
            )
        }

        return (stored + streaming).sorted {
            $0.message.createdAt < $1.message.createdAt
        }
    }

    var isThinking: Bool { thinkingState.isThinking }
    var elapsedTime: TimeInterval? { thinkingState.elapsedTime }
    var thinkingTime: TimeInterval? { thinkingState.thinkingTime }
    var isStreaming: Bool { streamState.isStreaming }

    var errorMessage: String? {
        if case .error(let message) = streamState {
            return message
        }
        return nil
    }

    // MARK: - Initialization

    init(
        apiClient: ChatMessageAPIClient = ChatMessageAPIClient(),
        thinkingState: ThinkingStateStore = ThinkingStateStore(),
        throttler: StreamThrottler = StreamThrottler()
    ) {
        self.apiClient = apiClient
        self.thinkingState = thinkingState
        self.throttler = throttler

        loadInitialMessages()

        Task {
            await throttler.setCallback { [weak self] chunk in
                self?.handleChunk(chunk)
            }
        }
    }

    private func loadInitialMessages() {
        Task {
            do {
                storedMessages = try await apiClient.fetchMessages()
                streamingMessages = []  // Clear any streaming messages on reload
            } catch {
                streamState = .error(error.localizedDescription)
            }
        }
    }

    // MARK: - Message Handling

    func sendMessage(with inputText: String, onStreamStart: (() -> Void)? = nil)
        async
    {
        let sanitizedInput = inputText.trimmingCharacters(
            in: .whitespacesAndNewlines)
        guard !sanitizedInput.isEmpty else { return }

        // Create temporary user message
        let tempId = UUID().uuidString
        let userMessage = StreamingMessage.createForUser(
            id: tempId,
            content: sanitizedInput
        )
        streamingMessages.append(userMessage)

        await startStreaming(
            message: sanitizedInput, onStreamStart: onStreamStart ?? {})
    }

    private func startStreaming(
        message: String, onStreamStart: @escaping () -> Void
    ) async {
        streamState = .starting
        thinkingState.isActive = true

        streamTask = Task {
            do {
                for try await event in try await apiClient.streamResponse(
                    message)
                {
                    streamState = .streaming

                    try await handleStreamEvent(
                        event, onStreamStart: onStreamStart)
                }
            } catch {
                await MainActor.run {
                    streamState = .error(error.localizedDescription)
                    cleanup()
                }
            }
        }

        await streamTask?.value
    }

    private func handleStreamEvent(_ data: String, onStreamStart: () -> Void)
        async throws
    {
        let event = try ChatMessageAPIClient.parseStreamEvent(data)

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

    private func handleChunk(_ chunk: BaseMessageChunk) {
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
        thinkingState.isActive = false
        streamTask?.cancel()
        streamTask = nil
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

    var isStreaming: Bool {
        switch self {
        case .starting, .streaming:
            return true
        default:
            return false
        }
    }
}
