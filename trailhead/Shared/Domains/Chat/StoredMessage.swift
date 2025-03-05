//
//  StoredMessage.swift
//  trailhead
//
//  Created by Robin Götz on 2/18/25.
//
import Foundation

struct StoredMessage: ChatMessage {
    let id: String
    let content: String
    let type: ChatMessageType
    let scope: ChatMessageScope
    let createdAt: Date
    let formatVersion: ChatMessageFormatVersion
    let currentStep: Int?
    let stepRepetitions: Int?
    let hasError: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, content, type, scope, createdAt, formatVersion, currentStep,
            stepRepetitions
    }

    init(
        id: String,
        content: String,
        type: ChatMessageType,
        scope: ChatMessageScope,
        createdAt: Date,
        formatVersion: ChatMessageFormatVersion,
        currentStep: Int?,
        stepRepetitions: Int?
    ) {
        self.id = id
        self.content = content
        self.type = type
        self.scope = scope
        self.createdAt = createdAt
        self.formatVersion = .v1
        self.currentStep = currentStep
        self.stepRepetitions = stepRepetitions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        type = try container.decode(ChatMessageType.self, forKey: .type)
        scope = try container.decode(ChatMessageScope.self, forKey: .scope)
        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        formatVersion = try container.decode(
            ChatMessageFormatVersion.self, forKey: .formatVersion)
        currentStep = try container.decodeIfPresent(
            Int.self, forKey: .currentStep)
        stepRepetitions = try container.decodeIfPresent(
            Int.self, forKey: .stepRepetitions)
    }

}

extension StoredMessage {
    static func from(_ chunk: ChatMessageChunk) -> StoredMessage {
        StoredMessage(
            id: chunk.id,
            content: chunk.textDelta ?? "",
            type: chunk.type ?? .aiMessage,
            scope: chunk.scope ?? .external,
            createdAt: chunk.createdAt,
            formatVersion: .v1,
            currentStep: chunk.currentStep,
            stepRepetitions: chunk.stepRepetitions
        )
    }
}
