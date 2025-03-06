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
    
    var fetchCombinedSurveyStatus: ResponseStatus<CombinedSurveyResponse> = .idle
    
    // MARK: - Fetch Methods
    
    /// Fetches both PRE and POST survey responses for a user
    /// - Parameters:
    ///   - userId: User ID to fetch surveys for
    ///   - onSuccess: Optional callback when request succeeds
    func fetchCombinedSurveys(
        userId: UUID,
        onSuccess: ((CombinedSurveyResponse) -> Void)? = nil
    ) {
        fetchCombinedSurveyStatus = .loading
        
        let uuidString = userId.uuidString.lowercased()
        
        // Build endpoint URL
        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("cidi")
            .appendingPathComponent(uuidString)
        
        // Build request
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue(
            authProvider.authorizationHeader(),
            forHTTPHeaderField: "Authorization")
        
        // Submit request
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // Handle request failure
            if let error = error {
                DispatchQueue.main.async {
                    print("[CidiAPI] Network error fetching surveys:", error)
                    self.fetchCombinedSurveyStatus = .error(
                        CidiAPIError.networkError(error))
                }
                return
            }
            
            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async {
                    print("[CidiAPI] Error: No survey response data returned")
                    self.fetchCombinedSurveyStatus = .error(
                        CidiAPIError.noDataReturned)
                }
                return
            }
            
            // Print response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("[CidiAPI] Response: \(jsonString)")
            }
            
            // Decode JSON response
            do {
                let decoder = JSONDecoder()
                // Don't need to set date decoding strategy, using custom decodeDate
                
                let response = try decoder.decode(
                    CombinedSurveyResponse.self, from: data)
                
                DispatchQueue.main.async {
                    print("[CidiAPI] Successfully fetched surveys - PRE: \(response.pre != nil), POST: \(response.post != nil)")
                    self.fetchCombinedSurveyStatus = .success(response)
                    onSuccess?(response)
                }
            } catch {
                DispatchQueue.main.async {
                    print("[CidiAPI] Survey response decoding error:", error)
                    // Print more details for debugging
                    if let decodingError = error as? DecodingError {
                        print("[CidiAPI] Decoding error details: \(decodingError)")
                    }
                    self.fetchCombinedSurveyStatus = .error(
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
    let createdAt: Date
    let updatedAt: Date?
    
    // Survey question fields
    let question10: Int?
    let question11: Int?
    let question12: Int?
    let question13: Int?
    let question14: Int?
    let question15: Int?
    let question16: Int?
    let question17: Int?
    let question20: Int?
    let question21: Int?
    let question22: Int?
    let question23: Int?
    let question24: Int?
    let question30: Int?
    let question31: Int?
    let question32: Int?
    let question33: Int?
    let question34: Int?
    let question35: Int?
    let question40: Int?
    let question41: Int?
    let question42: Int?
    let question50: Int?
    let question51: Int?
    let question52: Int?
    let question53: Int?
    let question54: Int?
    
    // Custom decoding for date handling
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        type = try container.decode(String.self, forKey: .type)
        createdAt = container.decodeDate(forKey: .createdAt) ?? Date()
        updatedAt = container.decodeDate(forKey: .updatedAt)
        
        // Decode all question fields
        question10 = try container.decodeIfPresent(Int.self, forKey: .question10)
        question11 = try container.decodeIfPresent(Int.self, forKey: .question11)
        question12 = try container.decodeIfPresent(Int.self, forKey: .question12)
        question13 = try container.decodeIfPresent(Int.self, forKey: .question13)
        question14 = try container.decodeIfPresent(Int.self, forKey: .question14)
        question15 = try container.decodeIfPresent(Int.self, forKey: .question15)
        question16 = try container.decodeIfPresent(Int.self, forKey: .question16)
        question17 = try container.decodeIfPresent(Int.self, forKey: .question17)
        question20 = try container.decodeIfPresent(Int.self, forKey: .question20)
        question21 = try container.decodeIfPresent(Int.self, forKey: .question21)
        question22 = try container.decodeIfPresent(Int.self, forKey: .question22)
        question23 = try container.decodeIfPresent(Int.self, forKey: .question23)
        question24 = try container.decodeIfPresent(Int.self, forKey: .question24)
        question30 = try container.decodeIfPresent(Int.self, forKey: .question30)
        question31 = try container.decodeIfPresent(Int.self, forKey: .question31)
        question32 = try container.decodeIfPresent(Int.self, forKey: .question32)
        question33 = try container.decodeIfPresent(Int.self, forKey: .question33)
        question34 = try container.decodeIfPresent(Int.self, forKey: .question34)
        question35 = try container.decodeIfPresent(Int.self, forKey: .question35)
        question40 = try container.decodeIfPresent(Int.self, forKey: .question40)
        question41 = try container.decodeIfPresent(Int.self, forKey: .question41)
        question42 = try container.decodeIfPresent(Int.self, forKey: .question42)
        question50 = try container.decodeIfPresent(Int.self, forKey: .question50)
        question51 = try container.decodeIfPresent(Int.self, forKey: .question51)
        question52 = try container.decodeIfPresent(Int.self, forKey: .question52)
        question53 = try container.decodeIfPresent(Int.self, forKey: .question53)
        question54 = try container.decodeIfPresent(Int.self, forKey: .question54)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, userId, type, createdAt, updatedAt
        case question10, question11, question12, question13, question14, question15, question16, question17
        case question20, question21, question22, question23, question24
        case question30, question31, question32, question33, question34, question35
        case question40, question41, question42
        case question50, question51, question52, question53, question54
    }
}

struct CombinedSurveyResponse: Codable {
    let pre: CidiSurveyResponse?
    let post: CidiSurveyResponse?
}
