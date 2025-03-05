//
//  StreamingMessage.swift
//  trailhead
//
//  Created by Robin Götz on 2/18/25.
//
import Foundation

struct StreamingMessage: ChatMessage {
    let id: String  // llmInteractionId for AI, runId for user
    private(set) var content: String
    let type: ChatMessageType
    let scope: ChatMessageScope
    let createdAt: Date
    let runId: String
    private(set) var currentStep: Int?
    private(set) var stepRepetitions: Int?
    private(set) var chunks: [ChatMessageChunk] = []
    
    var hasError: Bool {
       self.chunks.contains(where: { $0.chunkType == "error" })
    }
    

    mutating func appendChunk(_ chunk: ChatMessageChunk) {
        chunks.append(chunk)
        currentStep = chunk.currentStep
        stepRepetitions = chunk.stepRepetitions
        content += chunk.textDelta ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id, content, type, scope, createdAt, runId, currentStep,
            stepRepetitions, chunks
    }

    init(
        id: String,
        content: String,
        type: ChatMessageType,
        scope: ChatMessageScope,
        createdAt: Date,
        runId: String,
        currentStep: Int?,
        stepRepetitions: Int?
    ) {
        self.id = id
        self.content = content
        self.type = type
        self.scope = scope
        self.createdAt = createdAt
        self.runId = runId
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
        runId = try container.decode(String.self, forKey: .runId)
        currentStep = try container.decodeIfPresent(
            Int.self, forKey: .currentStep)
        stepRepetitions = try container.decodeIfPresent(
            Int.self, forKey: .stepRepetitions)
        chunks =
            try container.decodeIfPresent(
                [ChatMessageChunk].self, forKey: .chunks) ?? []
    }

}

extension StreamingMessage {
    static func createForUser(
        id: String,
        content: String,
        scope: ChatMessageScope = .external,
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
        scope: ChatMessageScope = .external,
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
