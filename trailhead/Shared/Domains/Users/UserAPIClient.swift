import Combine
//
//  UserAPIClient.swift
//  trailhead
//
//  Created by Robin Götz on 2/17/25.
//
import Foundation
import Observation

enum UserAPIError: Error {
    case userNotFound
    case noUserReturned
    case invalidUserUpdateData
    case invalidPersonalityData
}

/// A simple API client using URLSession, an auth provider, and status tracking.
@Observable final class UserAPIClient {
    private let session: URLSession
    private let authProvider: AuthorizationProvider

    /// - Parameters:
    ///   - session: Defaults to `URLSession.shared`, but can be injected for testing.
    ///   - authProvider: Anything that gives you an authorization header string.
    init(
        session: URLSession = .shared,
        authProvider: AuthorizationProvider
    ) {
        self.session = session
        self.authProvider = authProvider
    }

    /// Publishes the current state of fetching a user.
    var fetchUserStatus: ResponseStatus<User> = .idle
    /// Fetch a user from /api/users/{userId}.
    /// Adjust the decoding logic or path segments as needed.
    func fetchUser(by userId: UUID) {
        fetchUserStatus = .loading

        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("users")
            .appendingPathComponent(userId.uuidString.lowercased())

        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue(
            authProvider.authorizationHeader(),
            forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            // If we got a client/server error:
            if let error = error {
                DispatchQueue.main.async {
                    self.fetchUserStatus = .error(error)
                }
                return
            }

            // If no data came back:
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Error no user found")
                    self.fetchUserStatus = .error(UserAPIError.userNotFound)
                }
                return
            }

            // Attempt to decode into a User
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.fetchUserStatus = .success(user)
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    self.fetchUserStatus = .error(error)
                }
            }
        }
        .resume()
    }

    /// Publishes the current state of starting a new session
    var updateUserStatus: ResponseStatus<User> = .idle

    func updateUser(
        for userId: UUID, with dataToUpdate: UserUpdateData,
        onSuccess: ((_ user: User?) -> Void)?
    ) {
        updateUserStatus = .loading

        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("users")
            .appendingPathComponent(userId.uuidString.lowercased())

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        // Convert dictionary to JSON data
        guard let jsonData = try? encoder.encode(dataToUpdate) else {
            print("Error: Could not serialize JSON data")
            self.updateUserStatus = .error(UserAPIError.invalidUserUpdateData)
            return
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue(
            authProvider.authorizationHeader(),
            forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        session.dataTask(with: request) { data, response, error in

            // Handle request failure
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    self.updateUserStatus = .error(error)
                }
                return
            }

            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Error: No user returned")
                    self.updateUserStatus = .error(UserAPIError.noUserReturned)
                }
                return
            }

            print("\(String(describing: String(data: data, encoding: .utf8)))")

            // Decode JSON response
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.updateUserStatus = .success(user)
                    onSuccess?(user)
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error:", error)
                    self.updateUserStatus = .error(error)
                }
            }
        }
        .resume()
    }

    /// Publishes the current state of updating personality data
    var updatePersonalityStatus: ResponseStatus<PersonalityDataResponse> = .idle

    /// Updates a user's personality data at /api/users/{userId}/onboarding/personality
    /// - Parameters:
    ///   - userId: The UUID of the user to update
    ///   - personalityData: The personality data to send to the server
    ///   - onSuccess: Optional callback for when the update is successful
    func updatePersonality(
        for userId: UUID, with personalityData: PersonalityDataRequest,
        onSuccess: ((_ user: PersonalityDataResponse?) -> Void)?
    ) {
        updatePersonalityStatus = .loading

        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("users")
            .appendingPathComponent(userId.uuidString.lowercased())
            .appendingPathComponent("onboarding")
            .appendingPathComponent("personality")

        let encoder = JSONEncoder()

        // Convert data to JSON
        guard let jsonData = try? encoder.encode(personalityData) else {
            print("Error: Could not serialize personality data")
            self.updatePersonalityStatus = .error(
                UserAPIError.invalidPersonalityData)
            return
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue(
            authProvider.authorizationHeader(),
            forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        session.dataTask(with: request) { data, response, error in
            // Handle request failure
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    self.updatePersonalityStatus = .error(error)
                }
                return
            }

            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Error: No user returned")
                    self.updatePersonalityStatus = .error(
                        UserAPIError.noUserReturned)
                }
                return
            }

            print("\(String(describing: String(data: data, encoding: .utf8)))")

            // Decode JSON response
            do {
                let response = try JSONDecoder().decode(PersonalityDataResponse.self, from: data)
                DispatchQueue.main.async {
                    self.updatePersonalityStatus = .success(response)
                    onSuccess?(response)
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error:", error)
                    self.updatePersonalityStatus = .error(error)
                }
            }
        }
        .resume()
    }
}

struct UserUpdateData: Codable {
    let name: String?
    let pronouns: String?
    var birthday: Date?
    var graduationYear: Int?
    var referredBy: String?
    var cohort: String?
    var genderIdentity: String?
    var ethnicity: String?
    var competitionLevel: String?
    var ncaaDivision: String?
}


struct PersonalityDataRequest: Codable {
    var promptResponses: [PromptResponse]
    var mentorTraits: [String]
    var interests: [String]
    
    struct PromptResponse: Codable {
        var promptId: UUID
        var content: String
    }
}


struct UserPromptResponse: Hashable, Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let promptId: UUID
    let content: String?
    let createdAt: Date
    let updatedAt: Date?
    
    init(id: UUID, userId: UUID, promptId: UUID, content: String?, createdAt: Date, updatedAt: Date?) {
        self.id = id
        self.userId = userId
        self.promptId = promptId
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        promptId = try container.decode(UUID.self, forKey: .promptId)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        
        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        updatedAt = container.decodeDate(forKey: .updatedAt)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: UserPromptResponse, rhs: UserPromptResponse) -> Bool {
        return lhs.id == rhs.id
    }

}

struct PersonalityDataResponse: Codable {
    let promptResponses: [UserPromptResponse]
    let mentorTraits: [UserMentorTrait]
    let interests: [UserInterest]
}
