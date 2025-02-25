//
//  Session.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//
import Foundation

struct Session: Codable, Identifiable, Hashable {
    let id: UUID
    let slug: String?
    let name: String?
    let description: String?
    let stepCount: Int?
    let imageUrl: String?
    let index: Int
    let status: Status
    let estimatedCompletionTime: Int?
    let createdAt: Date
    let updatedAt: Date?
    let logs: [SessionLog]?

    var isCompleted: Bool {
        logs?.contains { $0.status == .completed } ?? false
    }

    enum Status: String, Codable {
        case active = "ACTIVE"
        case draft = "DRAFT"
    }

    enum CodingKeys: String, CodingKey {
        case id, slug, name, description, stepCount, imageUrl, index, status
        case estimatedCompletionTime, createdAt, updatedAt
        case logs
    }
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        slug = try container.decodeIfPresent(String.self, forKey: .slug)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        stepCount = try container.decodeIfPresent(Int.self, forKey: .stepCount)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        index = try container.decode(Int.self, forKey: .index)
        status = try container.decode(Status.self, forKey: .status)
        estimatedCompletionTime = try container.decodeIfPresent(Int.self, forKey: .estimatedCompletionTime)
       
        let decodedLogs = try container.decodeIfPresent([SessionLog].self, forKey: .logs) ?? []
        logs = decodedLogs.sorted { $0.createdAt > $1.createdAt }
        
        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        updatedAt = container.decodeDate(forKey: .updatedAt)
    }


    static func == (lhs: Session, rhs: Session) -> Bool {
        lhs.id == rhs.id
    }

}
