//
//  MentorQuality.swift
//  trailhead
//
//  Created by Robin Götz on 1/20/25.
//
import Foundation

struct UserMentorTrait: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String?
    let createdAt: Date
    let updatedAt: Date?
    
    init(id: UUID, name: String, description: String?, createdAt: Date, updatedAt: Date?) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        
        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        updatedAt = container.decodeDate(forKey: .updatedAt)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserMentorTrait, rhs: UserMentorTrait) -> Bool {
        return lhs.id == rhs.id
    }

}

let ALL_MENTOR_TRAITS: [UserMentorTrait] = [
    UserMentorTrait(
        id: UUID(uuidString: "114135a0-6ed3-4044-ae02-868ecf00355b")!,
        name: "Courage",
        description: "Faces life's messiness with grace, showing us how to do the same",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "86df954c-136a-4585-bc76-65bebc1987a9")!,
        name: "Wisdom",
        description: "Knows the difference between information and understanding",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "50236f5b-92fc-458e-acfc-e7331995eeb4")!,
        name: "Presence",
        description: "Truly listens, without rushing to fix or judge",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "aca39196-bc82-4e0b-95f7-2750a3e9425c")!,
        name: "Curiosity",
        description: "Delights in questions more than answers",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "180d0563-7a45-4819-b646-b3edaba392e7")!,
        name: "Truth",
        description: "Gentle with feelings, uncompromising with reality",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "24043b5a-5576-4534-9465-4b544735790b")!,
        name: "Depth",
        description: "Comfortable sitting with life's contradictions",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "393dd145-e4d0-4163-aa0d-01c39504ec1e")!,
        name: "Challenge",
        description: "Knows we grow most when we're slightly uncomfortable",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "d0e2d3e5-fb16-441a-b5cb-b470c9a96475")!,
        name: "Insight",
        description: "Sees patterns we've missed in our own story",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "2b6ce5eb-69d4-464e-aca5-7b555e73e635")!,
        name: "Trust",
        description: "Creates a space where doubts can be voiced",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "bbc5773d-0a44-4ee5-ba3f-7ccf8fb62561")!,
        name: "Heart",
        description: "Brings warmth to difficult conversations",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "7dd46897-85a8-495d-8162-759010657348")!,
        name: "Spirit",
        description: "Reminds us of life's poetry, not just its prose",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "65c4238d-3cec-4c74-aefd-463514555c62")!,
        name: "Vision",
        description: "Helps us imagine better versions of ourselves",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "e1514aa5-0cd7-409e-a174-cd18d1920743")!,
        name: "Faith",
        description: "Holds hope for us when we've misplaced our own",
        createdAt: Date(),
        updatedAt: nil
    ),
    UserMentorTrait(
        id: UUID(uuidString: "aee97886-2a8c-411c-8f6b-ed814db49f1f")!,
        name: "Purpose",
        description: "Helps us find meaning in the everyday",
        createdAt: Date(),
        updatedAt: nil
    )
]
