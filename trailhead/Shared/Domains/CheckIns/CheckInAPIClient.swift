//
//  CheckInAPIClient.swift
//  trailhead
//
//  Created by Robin Götz on 2/25/25.
//
import Foundation
import Observation

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
    
    func fetchCheckInSessions(for userId: UUID) {
        print("Fetching Check In sessions here")
    }
}
