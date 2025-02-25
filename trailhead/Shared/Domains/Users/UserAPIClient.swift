//
//  UserAPIClient.swift
//  trailhead
//
//  Created by Robin Götz on 2/17/25.
//
import Foundation
import Combine

enum UserAPIError: Error {
    case userNotFound
}

/// A simple API client using URLSession, an auth provider, and status tracking.
@Observable final class UserAPIClient {
    private let session: URLSession
    private let authProvider: AuthorizationProvider
    
    /// - Parameters:
    ///   - session: Defaults to `URLSession.shared`, but can be injected for testing.
    ///   - authProvider: Anything that gives you an authorization header string.
    init(session: URLSession = .shared,
         authProvider: AuthorizationProvider)
    {
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
        request.setValue(authProvider.authorizationHeader(), forHTTPHeaderField: "Authorization")
        
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
    
    func updateUser(with dataToUpdate: UserUpdateData, onSuccess: (() -> Void)?) async {
        print(dataToUpdate)
        onSuccess?()
    }
}

struct UserUpdateData {
    let name: String?
    let pronouns: String?
}
