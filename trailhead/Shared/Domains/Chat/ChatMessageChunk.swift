import Foundation

struct ChatMessageChunk: Codable {
    // Core properties
    let id: String
    let runId: String
    let chunkType: String
    let createdAt: Date
    
    // Everything else optional for robustness
    let type: ChatMessageType?
    let scope: ChatMessageScope?
    let textDelta: String?  // Now optional
    let toolCallId: String?
    let toolName: String?
    let args: [String: String]?
    let result: [String: String]?
    let currentStep: Int?
    let stepRepetitions: Int?
    
    // New fields from error JSON
    let finishReason: String?
    let usage: [String: Int]?
    let response: [String: String]?  // Simple dict enough for logging
    let isContinued: Bool?

    enum CodingKeys: String, CodingKey {
        case id, runId, type, scope, chunkType, textDelta, createdAt
        case toolCallId, toolName, args, result, currentStep, stepRepetitions
        case finishReason, usage, response, isContinued
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required fields
        id = try container.decode(String.self, forKey: .id)
        runId = try container.decode(String.self, forKey: .runId)
        chunkType = try container.decode(String.self, forKey: .chunkType)
        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        
        // Optional fields
        type = try container.decodeIfPresent(ChatMessageType.self, forKey: .type)
        scope = try container.decodeIfPresent(ChatMessageScope.self, forKey: .scope)
        textDelta = try container.decodeIfPresent(String.self, forKey: .textDelta)
        toolCallId = try container.decodeIfPresent(String.self, forKey: .toolCallId)
        toolName = try container.decodeIfPresent(String.self, forKey: .toolName)
        args = try container.decodeIfPresent([String: String].self, forKey: .args)
        result = try container.decodeIfPresent([String: String].self, forKey: .result)
        currentStep = try container.decodeIfPresent(Int.self, forKey: .currentStep)
        stepRepetitions = try container.decodeIfPresent(Int.self, forKey: .stepRepetitions)
        
        // New fields
        finishReason = try container.decodeIfPresent(String.self, forKey: .finishReason)
        usage = try container.decodeIfPresent([String: Int].self, forKey: .usage)
        response = try container.decodeIfPresent([String: String].self, forKey: .response)
        isContinued = try container.decodeIfPresent(Bool.self, forKey: .isContinued)
    }
}
