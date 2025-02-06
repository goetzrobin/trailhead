//
//  ChatMessageAPIClient.swift
//  trailhead
//
//  Created by Robin Götz on 2/6/25.
//
import Foundation

class ChatMessageAPIClient {
    // Mock history now uses StoredMessage
    private let mockHistory: [StoredMessage] = [
        StoredMessage(
            id: "hist_1",
            content:
                "Can you help me understand how to structure a SwiftUI app?",
            type: .userMessage,
            scope: .external,
            createdAt: Date().addingTimeInterval(-3600),
            formatVersion: .v1,
            currentStep: nil,
            stepRepetitions: nil
        ),
        StoredMessage(
            id: "hist_2",
            content:
                "Let me outline the key components of a well-structured SwiftUI app:\n\n1. Views: Your UI components\n2. ViewModels: Business logic and state management\n3. Models: Data structures\n4. Services: Network and data operations",
            type: .aiMessage,
            scope: .external,
            createdAt: Date().addingTimeInterval(-3500),
            formatVersion: .v1,
            currentStep: nil,
            stepRepetitions: nil
        ),
    ]

    // Mock responses to simulate streaming
    private let mockResponses = [
        "Based on your previous questions, let me elaborate on ViewModels in SwiftUI: They serve as the bridge between your UI and data layer, managing state and business logic.",
        "Let's look at a practical example:\n\n1. Use @Observable for your ViewModels\n2. Keep your Views focused on UI\n3. Leverage dependency injection",
        "The key to mastering SwiftUI is understanding the data flow. Start with small, focused components and gradually build up complexity.",
    ]

    func streamResponse(_ message: String) async throws -> AsyncStream<String> {
        AsyncStream { continuation in
            Task {
                // Start stream
                continuation.yield("data: [START]")
                try? await Task.sleep(for: .seconds(0.5))

                // Generate IDs for this interaction
                let runId = UUID().uuidString
                let llmInteractionId = UUID().uuidString
                let createdAt = Date()

                try? await Task.sleep(for: .seconds(1))

                // Get random response
                let response = mockResponses.randomElement() ?? mockResponses[0]

                // Convert response to array of characters
                let characters = Array(response)
                var currentIndex = 0
                
                // Stream response in variable-sized chunks
                while currentIndex < characters.count {
                    // Generate random chunk size between 3 and 5
                    let remainingChars = characters.count - currentIndex
                    let maxChunkSize = min(5, remainingChars)
                    let chunkSize = min(maxChunkSize, Int.random(in: 3...5))

                    // Extract chunk
                    let endIndex = min(
                        currentIndex + chunkSize, characters.count)
                    let chunk = String(characters[currentIndex..<endIndex])

                    let messageChunk = BaseMessageChunk(
                        id: llmInteractionId,
                        runId: runId,
                        type: .aiMessage,
                        scope: .external,
                        chunkType: "text",
                        textDelta: chunk,
                        createdAt: createdAt,
                        toolCallId: nil,
                        toolName: nil,
                        args: nil,
                        result: nil,
                        currentStep: nil,
                        stepRepetitions: nil
                    )

                    if let data = try? JSONEncoder().encode(messageChunk),
                        let json = String(data: data, encoding: .utf8)
                    {
                        continuation.yield("data: \(json)")
                        try? await Task.sleep(for: .seconds(0.05))
                    }

                    currentIndex = endIndex
                }

                try? await Task.sleep(for: .seconds(0.5))
                continuation.yield("data: [DONE]")
                continuation.finish()
            }
        }
    }

    func fetchMessages() async throws -> [StoredMessage] {
        try await Task.sleep(for: .seconds(0.5))  // Simulate network delay
        return mockHistory
    }

    static func parseStreamEvent(_ data: String) throws -> StreamEvent {
        guard data.hasPrefix("data: ") else {
            throw APIError.invalidEventFormat
        }

        let content = String(data.dropFirst(6))
        guard !content.isEmpty else { throw APIError.invalidChunkData }

        switch content {
        case "[START]":
            return .start
        case "[DONE]":
            return .done
        default:
            guard let jsonData = content.data(using: .utf8),
                let chunk = try? JSONDecoder().decode(
                    BaseMessageChunk.self, from: jsonData)
            else {
                throw APIError.invalidChunkData
            }
            return .chunk(chunk)
        }
    }
}

// MARK: - Helper Types

enum StreamEvent {
    case start
    case chunk(BaseMessageChunk)
    case done
    case error(Error)
}

// MARK: - Errors

enum APIError: Error {
    case invalidEventFormat
    case invalidChunkData
}
