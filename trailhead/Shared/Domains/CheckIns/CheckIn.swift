//
//  CheckIn.swift
//  trailhead
//
//  Created by Robin Götz on 2/12/25.
//
import Foundation

struct CheckIn: Identifiable {
    let id: UUID
    let userId: UUID
    let timestamp: Date
    let primaryEmotion: Emotion
    var secondaryEmotion: Emotion?
    var note: String?
    var activities: [String]
    var socialContexts: [String]
    var locations: [String]
    let createdAt: Date
    var updatedAt: Date
    var conversations: [Conversation]
}

struct Conversation: Identifiable {
    let id: UUID
    let checkInId: UUID
    let summary: String?
    var status: ConversationStatus
    let startedAt: Date
    var completedAt: Date?
    let createdAt: Date
    var updatedAt: Date
}

enum ConversationStatus {
    case inProgress
    case completed
}

extension CheckIn {
    static var example: CheckIn {
        CheckIn(
            id: UUID(),
            userId: UUID(),
            timestamp: Date(),
            primaryEmotion: Emotion.pleasantLowEnergy[0], // "Calm"
            secondaryEmotion: Emotion.pleasantHighEnergy[1], // "Excited"
            note: "Feeling centered after morning practice",
            activities: ["Meditation", "Reading"],
            socialContexts: ["Alone"],
            locations: ["Home", "Living Room"],
            createdAt: Date(),
            updatedAt: Date(),
            conversations: [
                Conversation(
                    id: UUID(),
                    checkInId: UUID(), // This would actually reference the parent CheckIn's id
                    summary: "Morning reflection after meditation",
                    status: .completed,
                    startedAt: Date().addingTimeInterval(-3600),
                    completedAt: Date(),
                    createdAt: Date().addingTimeInterval(-3600),
                    updatedAt: Date()
                ),
                Conversation(
                    id: UUID(),
                    checkInId: UUID(), // This would actually reference the parent CheckIn's id
                    summary: "Follow-up on morning feelings",
                    status: .inProgress,
                    startedAt: Date(),
                    completedAt: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                )
            ]
        )
    }
}
