//
//  ExcitedAboutOption.swift
//  trailhead
//
//  Created by Robin Götz on 1/20/25.
//
import Foundation

struct UserInterest: Codable, Identifiable, Hashable {
    let id: UUID
    let categoryId: UUID?
    let name: String
    let description: String?
    let createdAt: Date
    let updatedAt: Date?
    
    init(id: UUID, categoryId: UUID?, name: String, description: String?, createdAt: Date, updatedAt: Date?) {
        self.id = id
        self.categoryId = categoryId
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        categoryId = try container.decodeIfPresent(UUID.self, forKey: .categoryId)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        
        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        updatedAt = container.decodeDate(forKey: .updatedAt)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserInterest, rhs: UserInterest) -> Bool {
        return lhs.id == rhs.id
    }

}

// Model for interest categories
struct UserInterestCategory: Identifiable, Hashable {
    let id: UUID
    let name: String
    let iconName: String
    let interests: [UserInterest]
    
    // Add Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserInterestCategory, rhs: UserInterestCategory) -> Bool {
        return lhs.id == rhs.id
    }
}
let INTEREST_CATEGORIES: [UserInterestCategory] = [
    UserInterestCategory(
        id: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
        name: "At home",
        iconName: "house.fill",
        interests: [
            UserInterest(
                id: UUID(uuidString: "13d71a13-2de2-476a-88a4-e10cf762e4d8")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Creativity",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "0edb96a2-fc73-4a62-ac0f-b2e1a3a9c218")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Making music",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "06f370a5-2bc7-4b3b-8d2f-b0341fbe7101")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Spying on my neighbors",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "33cf22aa-78e2-477f-88b7-fe30af2ecb95")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Netflix & Chill",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "322b2734-893e-4485-a076-80399aecb7dc")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Plant parent",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "754fce17-8a27-4164-80e4-e8244e6a29d3")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Gardening",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "de3e04ec-f405-41c6-9346-ec6d0d04955c")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Cozy",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "cf6cb859-d749-4179-b6ab-11ed1310947d")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Cooking",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "8d3c3f62-00ef-49e6-9853-0a17c3857de6")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Board games",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "7d90f36a-3b7c-4956-aa30-3777a21037fb")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Sleeping in",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "648767e4-893d-4a15-b794-cf6380871f3a")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Staying in a bathrobe",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "18335dd7-dd9b-4fec-b635-8a18e7d3ba6d")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Ikea hacks",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "4de09e0f-9cce-4803-9790-7416cff73367")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Ceramics",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "2a479929-b71d-4bd9-a9ff-b91f7c497dc8")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Petting my cat",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "5ca48b9f-bce2-471d-b70f-28bc730d667a")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Fashion",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "5b335b6d-f32b-4b1c-adb5-9e16b5fe8959")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Dyson addict",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "903bbc48-b154-477a-8e89-53a268f6a834")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Afternoon nap",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "47fa8a8c-b8fd-4fe7-8edd-396a677804f8")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Singing in the shower",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "b381bedd-fd32-475f-92bc-f0d106d0abc7")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Marie Kondo",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "03495eb3-34be-4f78-bc71-69a2b1ae5e2f")!,
                categoryId: UUID(uuidString: "4444fdbe-9be0-418d-94e4-cce68bca3d22")!,
                name: "Meditation",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            )
        ]
    ),
    UserInterestCategory(
        id: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
        name: "Food & Drinks",
        iconName: "fork.knife",
        interests: [
            UserInterest(
                id: UUID(uuidString: "58fa1510-2bed-4e97-80a5-ffa248319027")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Pizza lover",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "bfae5a4a-cad0-45c9-b56e-17da8432251c")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Snack break",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "f8ddf0ff-f1e0-479d-928e-e9ba15615a89")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "The more cheese the better",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "c3244efd-4a68-4b02-9a30-1dc0c92b8ade")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Chocolate addict",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "7b464407-2d25-4914-96e8-5c544f999030")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Alcohol-free",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "1f92184d-01ff-4518-a395-01ec386a05f7")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "BBQ sauce",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "0994b0a5-915a-4bb5-b1c6-7c3dd1322905")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Chicken addict",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "eec76bb7-46b3-42ec-9d2f-20d9a2cd3df1")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Cocktails",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "ff76caaa-633f-47af-a004-0ed2f29d0854")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Hummus is the new caviar",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "a404c718-fe27-4d43-8b26-a9cd90e814a0")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Brunch",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "bf68341a-6477-49d0-b883-e9ec77b73ee1")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "BBQ",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "14c81523-42e9-42a9-ad0e-8396ab596e4b")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Street food",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "ca27bd72-b674-4dbf-a7a3-71aebf14581c")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Pasta or nothing",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "0637cf07-b580-4b59-b930-5504337ce8c5")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Wine and more wine",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "2aaffc55-b824-4945-a177-63ce2024d893")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Craft beer",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "b69bde93-3ba0-4b4e-8675-97bc0a51b8dd")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Spicy food",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "a6fa89fd-a106-4c8e-aeda-72842d64eb22")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "French fries",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "e5970f25-5d90-4cd9-8750-24eae261e276")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Ramen",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "5ad4d583-04ad-4942-9157-2f20f89ee35b")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Cheese",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "054d1156-2961-4522-bf36-885fa3b69ee4")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Healthy",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "3cb7694a-cd18-4a02-bf7b-80e13a362fe3")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Caffeine",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "f6153899-e343-4b72-8192-3d7a42d18437")!,
                categoryId: UUID(uuidString: "b73c619b-a5cb-432f-84bd-52ab4d1271ee")!,
                name: "Foodie",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            )
        ]
    ),
    UserInterestCategory(
        id: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
        name: "Geek",
        iconName: "gamecontroller.fill",
        interests: [
            UserInterest(
                id: UUID(uuidString: "e8831d51-6664-4538-be55-c84b1a4c8c40")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Gaming",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "465edb03-babe-4147-aacf-2e5400939d1b")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Puzzle",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "a44d07d3-4798-4646-84e5-762665b1f2ca")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Harry Potter",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "df3612eb-b4d6-4ab1-9eb6-9a49d6d85b29")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Retro Gaming",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "0b3d26e4-3a84-4a07-a2fa-89017a3fd862")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Manga & Anime",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "8084fb32-fb85-4a38-ac32-04333208c5c2")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Heroic Fantasy",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "afc09753-95d3-4ea1-8622-4a6ce969338c")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Chess mastermind",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "4d7a9c8d-71b2-419e-9fe3-e9d982ec18ac")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "YouTube",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "eafc6d58-5a80-4fe4-ac41-1c8c28c8bc4d")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Twitch",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "87eca7c8-936c-4c08-a875-1694d211f6aa")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Escape games",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "33b7222f-9eda-4854-88de-bafb45ec8a60")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Tamagotchi",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "56d52b39-e5da-4fb7-9849-f78b87f8f863")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Comics lover",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "382d6914-c4cc-40c8-865e-f0e86553004a")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Board games",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "688638ca-b5e0-4f2b-bd8b-b9325aae4c6b")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Cosplay",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "896112e4-87d8-46a9-ab4d-4d93e70f782e")!,
                categoryId: UUID(uuidString: "1d17c56f-1b23-4988-bde1-a63701b35ca9")!,
                name: "Japanese Culture",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            )
        ]
    ),
    UserInterestCategory(
        id: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
        name: "Unspoken habits",
        iconName: "person.fill.questionmark",
        interests: [
            UserInterest(
                id: UUID(uuidString: "3dbc7be1-0792-4f34-9d7e-b9128c1f36f5")!,
                categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                name: "Losing things",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "7dd5cb54-bddc-4703-991b-311576d534ba")!,
                categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                name: "Astral projecting",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "cdbba3b1-d498-4025-a920-1df5717de2cd")!,
                categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                name: "Avoiding the news",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "d70b0219-aeb7-43b3-8402-dd67fd52160a")!,
                categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                name: "Road rage",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "33d8cf5b-58a6-417b-8fa6-640acc827ccd")!,
                categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                name: "Small talk with strangers",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "3dc5c632-0783-4c7b-8766-6d002e25419d")!,
                categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                name: "Reading one-star reviews",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "eadff7b2-cc49-4e3a-9a92-195f7c4be5f6")!,
                categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                name: "Enjoying the smell of gas",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "da22864e-b278-4abf-9f8a-79d38991c0b8")!,
                categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                name: "Wikipedia random articles",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "0abfc8fd-6460-46d9-91df-143aefeb9b44")!,
                categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                name: "Starting books I'll never finish",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "bf3e4d7b-a434-44c7-a122-f15bea452781")!,
                categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                name: "TikTok trends specialist",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                        id: UUID(uuidString: "d118d2f9-b413-4235-b0a8-e36272fcfe60")!,
                        categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                        name: "Forgetting peoples' names",
                        description: nil,
                        createdAt: Date(),
                        updatedAt: nil
                    ),
                    UserInterest(
                        id: UUID(uuidString: "67cc1a72-0f11-4fa1-9929-efe7e77da597")!,
                        categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                        name: "Overthinking",
                        description: nil,
                        createdAt: Date(),
                        updatedAt: nil
                    ),
                    UserInterest(
                        id: UUID(uuidString: "9a09f4a9-b07c-4c58-9bfe-030ae50eeb0a")!,
                        categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                        name: "Making lists",
                        description: nil,
                        createdAt: Date(),
                        updatedAt: nil
                    ),
                    UserInterest(
                        id: UUID(uuidString: "ecae1e9c-afec-45d7-b07c-199daf9c4cd9")!,
                        categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                        name: "Me, a hypochondriac?",
                        description: nil,
                        createdAt: Date(),
                        updatedAt: nil
                    ),
                    UserInterest(
                        id: UUID(uuidString: "efb1e099-32b5-48f9-bbae-2813eb45144c")!,
                        categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                        name: "Opening too many tabs",
                        description: nil,
                        createdAt: Date(),
                        updatedAt: nil
                    ),
                    UserInterest(
                        id: UUID(uuidString: "f7814eb7-abee-4118-8ba0-b7a122ebe3d0")!,
                        categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                        name: "Looking at houses I can't afford",
                        description: nil,
                        createdAt: Date(),
                        updatedAt: nil
                    ),
                    UserInterest(
                        id: UUID(uuidString: "978fa5a4-9f65-42df-9074-07b3788b998b")!,
                        categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                        name: "Panic fear of spiders",
                        description: nil,
                        createdAt: Date(),
                        updatedAt: nil
                    ),
                    UserInterest(
                        id: UUID(uuidString: "bfb45b37-cc0d-4915-b996-3f64cc9d1cc2")!,
                        categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                        name: "Sleeping on my stomach",
                        description: nil,
                        createdAt: Date(),
                        updatedAt: nil
                    ),
                    UserInterest(
                        id: UUID(uuidString: "78db803c-acd9-4678-8631-999805b0b076")!,
                        categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                        name: "Uncontrollable cravings",
                        description: nil,
                        createdAt: Date(),
                        updatedAt: nil
                    ),
                    UserInterest(
                        id: UUID(uuidString: "5786bcb2-e4ca-494c-8d93-2276e647ba34")!,
                        categoryId: UUID(uuidString: "38662135-5c01-4053-9070-843c5ceeafab")!,
                        name: "Internet rabbit holes",
                        description: nil,
                        createdAt: Date(),
                        updatedAt: nil
                    )
                ]
            ),
    UserInterestCategory(
        id: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
        name: "Movies & TV Shows",
        iconName: "tv.fill",
        interests: [
            UserInterest(
                id: UUID(uuidString: "66136d35-f23c-4153-a7e7-0fc30bdfd0c8")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Re-runs of Friends",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "cc3470cb-93ac-47e5-812e-1893a0b3b522")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Going to the movies solo",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "f5f55b88-20f0-4e4e-bad7-9c73a008d018")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Cinema outdoor",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "b0b6f0ec-ffa9-44ee-9335-68b0e9053771")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Cooking shows",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "8f7bea1e-0eee-4102-b4b0-ffed9e8252f9")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Guessing the plot in 3s",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "f01129b5-d0dd-4b10-ab5c-bb1edc092fb5")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Reality shows",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "f0b8b509-8a09-4a19-9b26-47f81b8bba72")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Talking during the film",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "67155047-ba15-41a6-8492-10f395c49f8b")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Watching a series to fall asleep",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "2697235b-bd03-4134-9d16-7ac9babac997")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Documentaries fanatic",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "4049b316-aa98-41d0-b9a0-7941b4318475")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Tell spoilers by accident",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "0884c4df-c800-4cac-9151-0823e584a09e")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "HBO series",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "804e2799-bbdd-4c83-a39a-7724fae5972e")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Peer-to-peer",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "62f21d2e-7793-484b-a05e-528a68434e73")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Salty popcorn",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "2b98abd0-c9d5-4f10-a1f9-cea52c05a8a4")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "No trailers policy",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "287d6dd7-7996-42b1-9c97-f3e739a61ba1")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "True crime",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "fff45e9c-4f03-4793-8a22-70176c1776a0")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Sweet popcorn",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "2b1f5e5d-69b6-4b11-91ae-e8db74fea63a")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Quoting movies",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "c9bb88e9-87de-4503-a1dc-a20be55fb523")!,
                categoryId: UUID(uuidString: "d9edf255-753d-4526-90c0-4ae59777fac7")!,
                name: "Indie movies",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            )
        ]
    ),
    UserInterestCategory(
        id: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
        name: "Sport",
        iconName: "figure.run",
        interests: [
            UserInterest(
                id: UUID(uuidString: "f1b792e1-593f-484d-a7af-e1e9f398ffcd")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Bike rides",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "46e7118b-9eae-46e6-a5c8-b132b8140833")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Quidditch",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "10d8e3f1-9a60-41c6-aeb4-d1c8cb5a9b04")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Skateboard",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "3d6d6247-12c6-4969-8b55-cc72b5145796")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Running",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "6b13e990-ec71-4c8c-b684-7448c61e67bc")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Football",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "398f54f2-4511-49dc-a6b8-974a32c8d2c6")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Surf",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "29b05e97-e8bf-43e5-9773-0f927571f6ac")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Swimming",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "1fd3952f-bebb-4097-b5dd-d2ba595f031a")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Climbing",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "7016c316-0441-4e19-8a34-157d5dee7681")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Yoga",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "c8544295-71ad-465f-801c-e22cc155c006")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Formula 1",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "a255e925-479f-48af-9c67-2f8d17f0159f")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Boxing",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "cb1b8222-7959-4a24-a394-efe36ca63b94")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Tennis",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "8d43c8de-3a64-434e-8fc6-789992bdb146")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Basketball",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "5dad9661-96fa-4190-9f56-c461dc420083")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Rugby",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "edbafc1d-a4a1-4acf-a563-1c4005bb1321")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Horse riding",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "17b899ea-b766-4a07-8875-1c9d827639a9")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Gym clothes, no sport",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "870353cf-c479-427f-9a5e-ace443def673")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Dance",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "68ad6631-587a-417c-85f3-a5ba55f2a8d8")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Padel",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "4c2ec87e-e847-41f8-b791-0623ad01f76b")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Hitting the gym",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            UserInterest(
                id: UUID(uuidString: "36391baa-0069-4a6e-b485-018e8ab84108")!,
                categoryId: UUID(uuidString: "acb55d08-09f0-4e88-99f8-f11ccd3c5b2f")!,
                name: "Ski",
                description: nil,
                createdAt: Date(),
                updatedAt: nil
            )
        ]
    )
]
let ALL_USER_INTERESTS: [UserInterest] = INTEREST_CATEGORIES.flatMap { $0.interests }

