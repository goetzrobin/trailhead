//
//  AuthManager.swift
//  trailhead
//
//  Created by Robin Götz on 2/12/25.
//
import Foundation
import Observation
import Supabase
import SwiftUICore

@Observable final class AuthStore: Sendable, AuthorizationProvider {
    private var timer: Timer?

    var isAuthenticated: Bool = false
    var isOnboardingCompleted: Bool = false

    init() {
        subscribeToAuthChanges()
    }

    var sessionToken: String? {
        supabase.auth.currentSession?.accessToken
    }

    var userId: UUID? {
        supabase.auth.currentUser?.id
    }

    func authorizationHeader() -> String {
        "Bearer \(sessionToken ?? "")"
    }

    private func subscribeToAuthChanges() {
        Task {
            for await state in supabase.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(
                    state.event)
                {
                    isOnboardingCompleted =
                        parseOnboardingCompletedFromUserMeta(
                            user: state.session?.user)
                    isAuthenticated = state.session != nil
                } else {
                    isAuthenticated = false
                }
            }
        }
    }

    var signInStatus: ResponseStatus<Void> = .idle
    func signIn(email: String, password: String) async {
        signInStatus = .loading
        do {
            let data = try await supabase.auth.signIn(
                email: email, password: password)
            isOnboardingCompleted = parseOnboardingCompletedFromUserMeta(
                user: data.user)
            print("Success")
            signInStatus = .success(())
        } catch {
            print("Error")
            signInStatus = .error(error)
        }
    }

    var signUpStatus: ResponseStatus<Void> = .idle
    func signUp(email: String, password: String, onSuccess: (() -> Void)? = nil)
        async
    {
        signUpStatus = .loading
        do {
            _ = try await supabase.auth.signUp(
                email: email, password: password,
                data: [
                    "username": AnyJSON.string(email),
                    "onboarding_completed": AnyJSON.bool(false),
                ])
            signUpStatus = .success(())
            onSuccess?()
        } catch {
            print("error happened \(error)")
            signUpStatus = .error(error)
        }
    }

    var signOutStatus: ResponseStatus<Void> = .idle
    func signOut() async {
        signOutStatus = .loading
        do {
            try await supabase.auth.signOut()
            signOutStatus = .success(())
        } catch {
            print("error happened")
            signOutStatus = .error(error)
        }
    }

    var sendPasswordResetEmailStatus: ResponseStatus<Void> = .idle
    func sendPasswordResetEmail(to email: String) async {
        sendPasswordResetEmailStatus = .loading
        do {
            try await supabase.auth.resetPasswordForEmail(email)
            sendPasswordResetEmailStatus = .success(())
        } catch {
            print("error happened")
            sendPasswordResetEmailStatus = .error(error)
        }
    }

    var fetchUserStatus: ResponseStatus<Supabase.User> = .idle
    func fetchUser() async {
        fetchUserStatus = .loading
        do {
            let user = try await supabase.auth.user()
            isOnboardingCompleted = parseOnboardingCompletedFromUserMeta(
                user: user)
            isAuthenticated = user.isAnonymous == false
            fetchUserStatus = .success(user)
        } catch {
            print("error happened")
            fetchUserStatus = .error(error)
        }
    }

    private func parseOnboardingCompletedFromUserMeta(user: Supabase.User?)
        -> Bool
    {
        do {
            if user != nil
                && user?.userMetadata[
                    "onboarding_completed"] == nil
            {
                print("Legacy users don't have this set in metadata")
                return true
            }

            if let boolValue = try user?.userMetadata[
                "onboarding_completed"]?.decode(as: Bool.self)
            {
                return boolValue
            }
            if let stringValue = try user?.userMetadata[
                "onboarding_completed"]?.decode(as: String.self)
            {
                return stringValue.lowercased() == "true"
            }

            return false
        } catch {
            return false
        }
    }
}

extension AuthStore {
    func refreshSession() async {
        do {
            let session = try await supabase.auth.refreshSession()
            let expiresAtDate = Date(timeIntervalSince1970: session.expiresAt)
            let expiresIn = expiresAtDate.timeIntervalSinceNow
            scheduleSessionRefresh(after: expiresIn - 60)
        } catch {
            print("Session refresh failed: \(error)")
        }
    }

    private func scheduleSessionRefresh(after interval: TimeInterval) {
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(
                withTimeInterval: max(interval, 0), repeats: false
            ) { _ in
                Task {
                    await self.refreshSession()
                }
            }
        }
    }
}
