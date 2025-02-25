//
//  Untitled.swift
//  trailhead
//
//  Created by Robin Götz on 2/17/25.
//
import Foundation

struct User: Codable {
    let id: UUID
    let username: String
    let name: String
    let pronouns: String?
    let genderIdentity: String?
    let ethnicity: String?
    let competitionLevel: String?
    let ncaaDivision: String?
    let graduationYear: Int?
    let birthday: Date?
    let onboardingCompletedAt: Date?
    let offboardingInitiated: Date?
    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, username, name, pronouns, genderIdentity, ethnicity
        case competitionLevel, ncaaDivision, graduationYear, birthday
        case onboardingCompletedAt, offboardingInitiated, createdAt, updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        name = try container.decode(String.self, forKey: .name)
        pronouns = try container.decodeIfPresent(String.self, forKey: .pronouns)
        genderIdentity = try container.decodeIfPresent(String.self, forKey: .genderIdentity)
        ethnicity = try container.decodeIfPresent(String.self, forKey: .ethnicity)
        competitionLevel = try container.decodeIfPresent(String.self, forKey: .competitionLevel)
        ncaaDivision = try container.decodeIfPresent(String.self, forKey: .ncaaDivision)
        graduationYear = try container.decodeIfPresent(Int.self, forKey: .graduationYear)
        
        birthday = container.decodeDate(forKey: .birthday)
        onboardingCompletedAt = container.decodeDate(forKey: .onboardingCompletedAt)
        offboardingInitiated = container.decodeDate(forKey: .offboardingInitiated)
        createdAt = container.decodeDate(forKey: .createdAt)
        updatedAt = container.decodeDate(forKey: .updatedAt)
    }
}
