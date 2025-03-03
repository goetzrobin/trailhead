//
//  SessionLog.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//
import Foundation

struct SessionLog: Codable, Identifiable, Hashable {
    let id: UUID
    let userId: UUID
    let sessionId: UUID
    let preFeelingScore: Int?
    let preMotivationScore: Int?
    let preAnxietyScore: Int?
    let postFeelingScore: Int?
    let postMotivationScore: Int?
    let postAnxietyScore: Int?
    let version: Int
    let summary: String?
    let status: Status
    let startedAt: Date?
    let completedAt: Date?
    let createdAt: Date
    let updatedAt: Date?

    enum Status: String, Codable {
        case inProgress = "IN_PROGRESS"
        case completed = "COMPLETED"
        case aborted = "ABORTED"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        sessionId = try container.decode(UUID.self, forKey: .sessionId)
        preFeelingScore = try container.decodeIfPresent(
            Int.self, forKey: .preFeelingScore)
        preMotivationScore = try container.decodeIfPresent(
            Int.self, forKey: .preMotivationScore)
        preAnxietyScore = try container.decodeIfPresent(
            Int.self, forKey: .preAnxietyScore)
        postFeelingScore = try container.decodeIfPresent(
            Int.self, forKey: .postFeelingScore)
        postMotivationScore = try container.decodeIfPresent(
            Int.self, forKey: .postMotivationScore)
        postAnxietyScore = try container.decodeIfPresent(
            Int.self, forKey: .postAnxietyScore)
        version = try container.decode(Int.self, forKey: .version)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        status = try container.decode(Status.self, forKey: .status)

        startedAt = container.decodeDate(forKey: .startedAt)
        completedAt = container.decodeDate(forKey: .completedAt)
        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        updatedAt = container.decodeDate(forKey: .updatedAt)
    }
}
