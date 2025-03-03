//
//  CompleteOnboardingAPIClient.swift
//  trailhead
//
//  Created by Robin Götz on 3/2/25.
//
import Foundation
import Observation

/// Enum for API errors related to onboarding operations
enum OnboardingError: Error {
    case invalidData
    case noProfileReturned
    case decodingError
}

@Observable class CompleteOnboardingAPIClient {
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

    /// Publishes the current state of completing onboarding
    var completeOnboardingStatus: ResponseStatus<UserProfile> = .idle

    /// Completes the user's onboarding process at /api/users/{userId}/onboarding/complete
    /// - Parameters:
    ///   - userId: The UUID of the user to update
    ///   - onSuccess: Optional callback for when the update is successful
    func completeOnboarding(
        for userId: UUID,
        onSuccess: ((_ profile: UserProfile?) -> Void)?
    ) {
        completeOnboardingStatus = .loading

        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("users")
            .appendingPathComponent(userId.uuidString.lowercased())
            .appendingPathComponent("onboarding")
            .appendingPathComponent("complete")

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue(
            authProvider.authorizationHeader(),
            forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        session.dataTask(with: request) { data, response, error in
            // Handle request failure
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    self.completeOnboardingStatus = .error(error)
                }
                return
            }

            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Error: No profile returned")
                    self.completeOnboardingStatus = .error(
                        OnboardingError.noProfileReturned)
                }
                return
            }

            print("\(String(describing: String(data: data, encoding: .utf8)))")

            // Decode JSON response
            do {
                let profile = try JSONDecoder().decode(
                    UserProfile.self, from: data)
                DispatchQueue.main.async {
                    self.completeOnboardingStatus = .success(profile)
                    onSuccess?(profile)
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error:", error)
                    self.completeOnboardingStatus = .error(
                        OnboardingError.decodingError)
                }
            }
        }
        .resume()
    }
}

// Response model for user profile based on the schema
struct UserProfile: Codable, Identifiable, Hashable {
    let id: UUID
    let userId: UUID
    let currentStateOfMind: String?
    let perceivedCareerReadiness: String?
    let coreValues: String?
    let aspirations: String?
    let createdAt: Date
    let updatedAt: Date?
    let sessionLogId: UUID?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        currentStateOfMind = try container.decodeIfPresent(
            String.self, forKey: .currentStateOfMind)
        perceivedCareerReadiness = try container.decodeIfPresent(
            String.self, forKey: .perceivedCareerReadiness)
        coreValues = try container.decodeIfPresent(
            String.self, forKey: .coreValues)
        aspirations = try container.decodeIfPresent(
            String.self, forKey: .aspirations)

        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        updatedAt = container.decodeDate(forKey: .updatedAt)

        sessionLogId = try container.decodeIfPresent(
            UUID.self, forKey: .sessionLogId)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id
    }
}
