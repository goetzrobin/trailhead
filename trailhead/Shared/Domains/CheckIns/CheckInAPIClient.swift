//
//  CheckInAPIClient.swift
//  trailhead
//
//  Created by Robin Götz on 2/25/25.
//
import Foundation
import Observation

enum CheckInAPIError: Error {
    case noDataReturned
}

@Observable class CheckInAPIClient {
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
    var fetchCheckInLogsStatus: ResponseStatus<[SessionLog]> = .idle
    
    /// Fetches all sessions with logs for a given user.
    /// Calls `/api/users/{userId}/sessions` and decodes into `[Session]` model.
    func fetchCheckInLogs(for userId: UUID) {
        fetchCheckInLogsStatus = .loading
        
        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("users")
            .appendingPathComponent(userId.uuidString.lowercased())
            .appendingPathComponent("session-logs")
            .appendingPathComponent("unguided")  // /api/users/{userId}/session-logs/unguided
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue(authProvider.authorizationHeader(), forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // Handle request failure
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    self.fetchCheckInLogsStatus = .error(error)
                }
                return
            }
            
            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Error: No sessions found")
                    self.fetchCheckInLogsStatus = .error(CheckInAPIError.noDataReturned)
                }
                return
            }
            
            // Decode JSON response
            do {
                let sessions = try JSONDecoder().decode([SessionLog].self, from: data)
                DispatchQueue.main.async {
                    self.fetchCheckInLogsStatus = .success(sessions)
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error:", error)
                    self.fetchCheckInLogsStatus = .error(error)
                }
            }
        }
        .resume()
    }
}
