//
//  BaseMessageChunk.swift
//  trailhead
//
//  Created by Robin Götz on 2/18/25.
//
import Foundation

struct ChatMessageChunk: Codable {
    let id: String
    let runId: String
    let type: ChatMessageType?
    let scope: ChatMessageScope?
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
    
    init(
        id: String,
        runId: String,
        type: ChatMessageType?,
        scope: ChatMessageScope?,
        chunkType: String,
        textDelta: String,
        createdAt: Date,
        toolCallId: String?,
        toolName: String?,
        args: [String: String]?,
        result: [String: String]?,
        currentStep: Int?,
        stepRepetitions: Int?
    ) {
        self.id = id
        self.runId = runId
        self.type = type
        self.scope = scope
        self.chunkType = chunkType
        self.textDelta = textDelta
        self.createdAt = createdAt
        self.toolCallId = toolCallId
        self.toolName = toolName
        self.args = args
        self.result = result
        self.currentStep = currentStep
        self.stepRepetitions = stepRepetitions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        runId = try container.decode(String.self, forKey: .runId)
        type = try container.decodeIfPresent(
            ChatMessageType.self, forKey: .type)
        scope = try container.decodeIfPresent(
            ChatMessageScope.self, forKey: .scope)
        chunkType = try container.decode(String.self, forKey: .chunkType)
        textDelta = try container.decode(String.self, forKey: .textDelta)
        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        toolCallId = try container.decodeIfPresent(
            String.self, forKey: .toolCallId)
        toolName = try container.decodeIfPresent(String.self, forKey: .toolName)
        args = try container.decodeIfPresent(
            [String: String].self, forKey: .args)
        result = try container.decodeIfPresent(
            [String: String].self, forKey: .result)
        currentStep = try container.decodeIfPresent(
            Int.self, forKey: .currentStep)
        stepRepetitions = try container.decodeIfPresent(
            Int.self, forKey: .stepRepetitions)
    }
}
