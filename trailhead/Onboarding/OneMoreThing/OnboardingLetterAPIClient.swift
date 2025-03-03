//
//  OnboardingLetterAPIClient.swift
//  trailhead
//
//  Created by Robin Götz on 3/2/25.
//

import Foundation
import Observation

enum OnboardingLetterAPIError: Error {
    case invalidOnboardingLetterData
    case noLetterDataReturned
}

@Observable class OnboardingLetterAPIClient {
    private let session: URLSession
    private let authProvider: AuthorizationProvider
    
    /// - Parameters:
    ///   - session: Defaults to `URLSession.shared`, but can be injected for testing.
    ///   - authProvider: Provides an authorization header string.
    init(session: URLSession = .shared,
         authProvider: AuthorizationProvider) {
        self.session = session
        self.authProvider = authProvider
    }
    
    /// Publishes the current state of submitting onboarding letter
    var submitOnboardingLetterStatus: ResponseStatus<OnboardingLetterResponse> = .idle
    
    /// Submits a user's onboarding letter at /api/onboarding/letters/{userId}
    /// - Parameters:
    ///   - userId: The UUID of the user
    ///   - content: The letter content to submit
    ///   - onSuccess: Optional callback for when the submission is successful
    func submitOnboardingLetter(
        for userId: UUID,
        with content: String,
        onSuccess: ((_ letter: OnboardingLetterResponse?) -> Void)?
    ) {
        submitOnboardingLetterStatus = .loading
        
        guard let endpoint = buildEndpoint(for: userId) else {
            submitOnboardingLetterStatus = .error(OnboardingLetterAPIError.invalidOnboardingLetterData)
            return
        }
        
        guard let request = buildRequest(for: endpoint, userId: userId, content: content) else {
            submitOnboardingLetterStatus = .error(OnboardingLetterAPIError.invalidOnboardingLetterData)
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.handleResponse(data: data, error: error, onSuccess: onSuccess)
            }
        }
        .resume()
    }
    
    // MARK: - Private Helper Methods
    
    /// Constructs the API endpoint URL
    private func buildEndpoint(for userId: UUID) -> URL? {
        guard let baseURL = URL(string: env.API_ROOT_URL) else { return nil }
        
        return baseURL
            .appendingPathComponent("api/onboarding/letters")
            .appendingPathComponent(userId.uuidString.lowercased())
    }
    
    /// Constructs the HTTP request for onboarding letter submission
    private func buildRequest(for url: URL, userId: UUID, content: String) -> URLRequest? {
        let requestBody = OnboardingLetterRequest(userId: userId.uuidString.lowercased(), content: content)
        
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            print("Error: Could not serialize onboarding letter data")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(authProvider.authorizationHeader(), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        return request
    }
    
    /// Handles the API response
    private func handleResponse(
        data: Data?,
        error: Error?,
        onSuccess: ((_ letter: OnboardingLetterResponse?) -> Void)?
    ) {
        if let error = error {
            print("Request failed with error:", error.localizedDescription)
            submitOnboardingLetterStatus = .error(error)
            return
        }
        
        guard let data = data else {
            print("Error: No data received")
            submitOnboardingLetterStatus = .error(OnboardingLetterAPIError.noLetterDataReturned)
            return
        }
        
        do {
            let response = try JSONDecoder().decode(OnboardingLetterResponse.self, from: data)
            submitOnboardingLetterStatus = .success(response)
            onSuccess?(response)
        } catch {
            print("Decoding error:", error)
            submitOnboardingLetterStatus = .error(error)
        }
    }
}

// MARK: - Request Model
fileprivate struct OnboardingLetterRequest: Codable {
    let userId: String
    let content: String
}

// MARK: - Response Model
struct OnboardingLetterResponse: Hashable, Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let content: String?
    let createdAt: Date
    let updatedAt: Date?
    
    init(id: UUID, userId: UUID, content: String?, createdAt: Date, updatedAt: Date?) {
        self.id = id
        self.userId = userId
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        
        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        updatedAt = container.decodeDate(forKey: .updatedAt)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: OnboardingLetterResponse, rhs: OnboardingLetterResponse) -> Bool {
        return lhs.id == rhs.id
    }
}
