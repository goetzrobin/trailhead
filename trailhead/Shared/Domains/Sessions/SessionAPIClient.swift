//
//  SessionAPIClient.swift
//  trailhead
//
//  Created by Robin Götz on 2/17/25.
//
import Foundation
import Combine
import Observation

enum SessionAPIError: Error {
    case sessionsNotFound
    case invalidStartSessionScores
    case noSessionLogReturnedFromStart
    case invalidEndSessionScores
}

/// A simple API client using URLSession, an auth provider, and status tracking.
@Observable final class SessionAPIClient {
    private let session: URLSession
    private let authProvider: AuthorizationProvider

    /// - Parameters:
    ///   - session: Defaults to `URLSession.shared`, but can be injected for testing.
    ///   - authProvider: Anything that gives you an authorization header string.
    init(session: URLSession = .shared,
         authProvider: AuthorizationProvider) {
        self.session = session
        self.authProvider = authProvider
    }

    /// Publishes the current state of fetching sessions with logs.
    var fetchSessionsStatus: ResponseStatus<[Session]> = .idle

    /// Fetches all sessions with logs for a given user.
    /// Calls `/api/users/{userId}/sessions` and decodes into `[Session]` model.
    func fetchSessionsWithLogs(for userId: UUID) {
        fetchSessionsStatus = .loading

        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("users")
            .appendingPathComponent(userId.uuidString.lowercased())
            .appendingPathComponent("sessions")  // /api/users/{userId}/sessions

        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue(authProvider.authorizationHeader(), forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            // Handle request failure
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    self.fetchSessionsStatus = .error(error)
                }
                return
            }

            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Error: No sessions found")
                    self.fetchSessionsStatus = .error(SessionAPIError.sessionsNotFound)
                }
                return
            }

            // Decode JSON response
            do {
                let sessions = try JSONDecoder().decode([Session].self, from: data)
                DispatchQueue.main.async {
                    self.fetchSessionsStatus = .success(sessions)
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error:", error)
                    self.fetchSessionsStatus = .error(error)
                }
            }
        }
        .resume()
    }
    
    
    /// Publishes the current state of starting a new session
    var startSessionStatus: ResponseStatus<SessionLog> = .idle

    /// Starts a new session for a given user and slug
    /// Calls `/api/users/${userId}/sessions/slug/${slug}/start` and decodes into `SessionLog` model.
    func startSession(with slug: String, for userId: UUID, scores: SessionScores, onSuccess: ((_: SessionLog) -> Void)?) {
        startSessionStatus = .loading

        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("users")
            .appendingPathComponent(userId.uuidString.lowercased())
            .appendingPathComponent("sessions")
            .appendingPathComponent("slug")
            .appendingPathComponent(slug)
            .appendingPathComponent("start")
        
        guard let feelingScore = scores.feelingScore,
                  let motivationScore = scores.motivationScore,
                  let anxietyScore = scores.anxietyScore else {
                self.startSessionStatus = .error(SessionAPIError.invalidStartSessionScores)
                return
            }
            
            // Create a dictionary matching the expected JSON structure
            let requestDict: [String: Int] = [
                "preFeelingScore": feelingScore,
                "preMotivationScore": motivationScore,
                "preAnxietyScore": anxietyScore
            ]
        
        print("request \(requestDict)")
            
            // Convert dictionary to JSON data
            guard let jsonData = try? JSONSerialization.data(withJSONObject: requestDict) else {
                print("Error: Could not serialize JSON data")
                self.startSessionStatus = .error(SessionAPIError.invalidStartSessionScores)
                return
            }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue(authProvider.authorizationHeader(), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            print("response \(response)")

            // Handle request failure
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    self.startSessionStatus = .error(error)
                }
                return
            }

            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Error: No session log returned")
                    self.startSessionStatus = .error(SessionAPIError.noSessionLogReturnedFromStart)
                }
                return
            }

            // Decode JSON response
            do {
                let sessionLog = try JSONDecoder().decode(SessionLog.self, from: data)
                DispatchQueue.main.async {
                    self.startSessionStatus = .success(sessionLog)
                    onSuccess?(sessionLog)
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error:", error)
                    self.startSessionStatus = .error(error)
                }
            }
        }
        .resume()
    }
    
    
    /// Publishes the current state of starting a new session
    var endSessionStatus: ResponseStatus<SessionLog> = .idle

    /// Ends a session for a given log id
    /// Calls `/api/session-logs/${sessionLogId}/end` and decodes into `SessionLog` model.
    func endSession(ofLogWithId sessionLogId: UUID, scores: SessionScores, onSuccess: ((_: SessionLog) -> Void)?) {
        endSessionStatus = .loading

        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("session-logs")
            .appendingPathComponent(sessionLogId.uuidString.lowercased())
            .appendingPathComponent("end")
        
        guard let feelingScore = scores.feelingScore,
                  let motivationScore = scores.motivationScore,
                  let anxietyScore = scores.anxietyScore else {
                self.endSessionStatus = .error(SessionAPIError.invalidEndSessionScores)
                return
            }
            
            // Create a dictionary matching the expected JSON structure
            let requestDict: [String: Int] = [
                "postFeelingScore": feelingScore,
                "postMotivationScore": motivationScore,
                "postAnxietyScore": anxietyScore
            ]
        
        print("request \(requestDict)")
            
            // Convert dictionary to JSON data
            guard let jsonData = try? JSONSerialization.data(withJSONObject: requestDict) else {
                print("Error: Could not serialize JSON data")
                self.endSessionStatus = .error(SessionAPIError.invalidStartSessionScores)
                return
            }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue(authProvider.authorizationHeader(), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            // Handle request failure
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    self.endSessionStatus = .error(error)
                }
                return
            }

            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Error: No session log returned")
                    self.endSessionStatus = .error(SessionAPIError.noSessionLogReturnedFromStart)
                }
                return
            }

            // Decode JSON response
            do {
                let sessionLog = try JSONDecoder().decode(SessionLog.self, from: data)
                DispatchQueue.main.async {
                    self.endSessionStatus = .success(sessionLog)
                    onSuccess?(sessionLog)
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error:", error)
                    self.endSessionStatus = .error(error)
                }
            }
        }
        .resume()
    }
}
