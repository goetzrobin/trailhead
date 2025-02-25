//
//  CidiAPIClient.swift
//  trailhead
//
//  Created by Robin Götz on 2/25/25.
//

import Foundation

// MARK: - Error types
enum CidiAPIError: Error {
    case invalidAnswers
    case jsonSerializationFailed
    case networkError(Error)
    case noDataReturned
    case decodingError(Error)
}

@Observable class CidiAPIClient {
    // MARK: - Properties
    private let session: URLSession
    private let authProvider: AuthorizationProvider

    // Status publishers
    var submitCidiSurveyStatus: ResponseStatus<CidiSurveyResponse> = .idle

    // MARK: - Initialization
    init(session: URLSession = .shared, authProvider: AuthorizationProvider) {
        self.session = session
        self.authProvider = authProvider
    }

    // MARK: - API Methods

    /// Submits CIDI survey results to the API for pre survey
    /// - Parameters:
    ///   - userId: User ID to submit survey for
    ///   - cidiState: The CidiState containing survey answers
    ///   - onSuccess: Optional callback when request succeeds
    func submitPreCidiSurvey(
        userId: UUID, answers: [String: Any],
        onSuccess: ((CidiSurveyResponse) -> Void)? = nil
    ) {
        self.submitCidiSurvey(
            timing: .pre, userId: userId,
            answers: answers, onSuccess: onSuccess)
    }
    
    /// Submits CIDI survey results to the API for pre survey
    /// - Parameters:
    ///   - userId: User ID to submit survey for
    ///   - cidiState: The CidiState containing survey answers
    ///   - onSuccess: Optional callback when request succeeds
    func submitPostCidiSurvey(
        userId: UUID, answers: [String: Any],
        onSuccess: ((CidiSurveyResponse) -> Void)? = nil
    ) {
        self.submitCidiSurvey(
            timing: .post, userId: userId,
            answers: answers, onSuccess: onSuccess)
    }

    private func submitCidiSurvey(
        timing: CidiTiming,
        userId: UUID, answers: [String: Any],
        onSuccess: ((CidiSurveyResponse) -> Void)? = nil
    ) {
        submitCidiSurveyStatus = .loading

        let uuidString = userId.uuidString.lowercased()
        // Build endpoint URL
        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("cidi")
            .appendingPathComponent(timing == .pre ? "pre" : "post")
            .appendingPathComponent(uuidString)

        // Add userId
        var cidiAnswers = answers
        cidiAnswers["userId"] = uuidString

        // Convert to JSON
        guard
            let jsonData = try? JSONSerialization.data(
                withJSONObject: cidiAnswers)
        else {
            print("Error: Could not serialize CIDI survey JSON data")
            self.submitCidiSurveyStatus = .error(
                CidiAPIError.jsonSerializationFailed)
            return
        }

        // Build request
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue(
            authProvider.authorizationHeader(),
            forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Submit request
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            // Handle request failure
            if let error = error {
                DispatchQueue.main.async {
                    print("CIDI API error:", error)
                    self.submitCidiSurveyStatus = .error(
                        CidiAPIError.networkError(error))
                }
                return
            }

            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Error: No CIDI survey response returned")
                    self.submitCidiSurveyStatus = .error(
                        CidiAPIError.noDataReturned)
                }
                return
            }

            // Decode JSON response
            do {
                let response = try JSONDecoder().decode(
                    CidiSurveyResponse.self, from: data)
                DispatchQueue.main.async {
                    self.submitCidiSurveyStatus = .success(response)
                    onSuccess?(response)
                }
            } catch {
                DispatchQueue.main.async {
                    print("CIDI survey decoding error:", error)
                    self.submitCidiSurveyStatus = .error(
                        CidiAPIError.decodingError(error))
                }
            }
        }
        .resume()
    }

}

// MARK: - Response models
struct CidiSurveyResponse: Codable {
    let id: UUID
    let userId: String
    let type: String
    //    let createdAt: Date
    // Add any additional fields returned by your API
}
