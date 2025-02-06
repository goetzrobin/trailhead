import Foundation

// MARK: - Enums

enum BaseMessageType: String, Codable {
    case aiMessage = "ai-message"
    case toolCall = "tool-call"
    case userMessage = "user-message"
    case analyzer = "analyzer"
    case executeStep = "execute-step"
    case error = "error"
}

enum BaseMessageScope: String, Codable {
    case `internal`
    case external
}

enum BaseMessageFormatVersion: Int, Codable {
    case v1 = 1
}

// MARK: - Protocols

protocol ChatMessage: Codable {
    var id: String { get }
    var content: String { get }
    var type: BaseMessageType { get }
    var scope: BaseMessageScope { get }
    var createdAt: Date { get }
    var currentStep: Int? { get }
    var stepRepetitions: Int? { get }
}

// MARK: - Message Types

struct StoredMessage: ChatMessage {
    let id: String
    let content: String
    let type: BaseMessageType
    let scope: BaseMessageScope
    let createdAt: Date
    let formatVersion: BaseMessageFormatVersion
    let currentStep: Int?
    let stepRepetitions: Int?
}

struct StreamingMessage: ChatMessage {
    let id: String           // llmInteractionId for AI, runId for user
    private(set) var content: String
    let type: BaseMessageType
    let scope: BaseMessageScope
    let createdAt: Date
    let runId: String
    let currentStep: Int?
    let stepRepetitions: Int?
    private(set) var chunks: [BaseMessageChunk] = []
    
    mutating func appendChunk(_ chunk: BaseMessageChunk) {
        chunks.append(chunk)
        content += chunk.textDelta
    }
}

// MARK: - Chunk Type

struct BaseMessageChunk: Codable {
    let id: String
    let runId: String
    let type: BaseMessageType?
    let scope: BaseMessageScope?
    let chunkType: String
    let textDelta: String
    let createdAt: Date
    let toolCallId: String?
    let toolName: String?
    let args: [String: String]?
    let result: [String: String]?
    let currentStep: Int?
    let stepRepetitions: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, runId, type, scope, chunkType, textDelta, createdAt
        case toolCallId, toolName, args, result, currentStep, stepRepetitions
    }
}

// MARK: - Extensions

extension StoredMessage {
    static func from(_ chunk: BaseMessageChunk) -> StoredMessage {
        StoredMessage(
            id: chunk.id,
            content: chunk.textDelta,
            type: chunk.type ?? .aiMessage,
            scope: chunk.scope ?? .external,
            createdAt: chunk.createdAt,
            formatVersion: .v1,
            currentStep: chunk.currentStep,
            stepRepetitions: chunk.stepRepetitions
        )
    }
}

extension StreamingMessage {
    static func createForUser(
        id: String,
        content: String,
        scope: BaseMessageScope = .external,
        createdAt: Date = Date()
    ) -> StreamingMessage {
        StreamingMessage(
            id: id,
            content: content,
            type: .userMessage,
            scope: scope,
            createdAt: createdAt,
            runId: id,
            currentStep: nil,
            stepRepetitions: nil
        )
    }
    
    static func createForAI(
        llmInteractionId: String,
        runId: String,
        scope: BaseMessageScope = .external,
        createdAt: Date = Date()
    ) -> StreamingMessage {
        StreamingMessage(
            id: llmInteractionId,
            content: "",
            type: .aiMessage,
            scope: scope,
            createdAt: createdAt,
            runId: runId,
            currentStep: nil,
            stepRepetitions: nil
        )
    }
}
