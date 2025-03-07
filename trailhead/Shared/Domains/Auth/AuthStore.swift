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
        print("[AUTH] AuthStore initialized")
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
        print("[AUTH] Subscribing to auth changes")
        Task {
            for await state in supabase.auth.authStateChanges {
                print("[AUTH] Auth state changed: \(state.event.rawValue)")
                if [.initialSession, .signedIn, .signedOut, .tokenRefreshed].contains(
                    state.event)
                {
                    isOnboardingCompleted =
                        parseOnboardingCompletedFromUserMeta(
                            user: state.session?.user)
                    isAuthenticated = state.event == .signedOut || state.session != nil
                    print("[AUTH] Auth updated - authenticated: \(self.isAuthenticated), onboarding completed: \(self.isOnboardingCompleted)")
                }
            }
        }
    }

    var signInStatus: ResponseStatus<Void> = .idle
    func signIn(email: String, password: String) async {
        print("[AUTH] Attempting sign in for user: \(email)")
        signInStatus = .loading
        do {
            let data = try await supabase.auth.signIn(
                email: email, password: password)
            DispatchQueue.main.async {
                self.isOnboardingCompleted = self.parseOnboardingCompletedFromUserMeta(
                    user: data.user)
                print("[AUTH] Sign in successful for user: \(email)")
                self.signInStatus = .success(())
            }
        } catch {
            print("[AUTH] Sign in failed for \(email): \(error)")
            signInStatus = .error(error)
        }
    }

    var signUpStatus: ResponseStatus<Void> = .idle
    func signUp(email: String, password: String, onSuccess: (() -> Void)? = nil)
        async
    {
        print("[AUTH] Attempting sign up for user: \(email)")
        signUpStatus = .loading
        do {
            _ = try await supabase.auth.signUp(
                email: email, password: password,
                data: [
                    "username": AnyJSON.string(email),
                    "onboarding_completed": AnyJSON.bool(false),
                ])
            print("[AUTH] Sign up successful for user: \(email)")
            signUpStatus = .success(())
            onSuccess?()
        } catch {
            print("[AUTH] Sign up failed for \(email): \(error)")
            signUpStatus = .error(error)
        }
    }

    var signOutStatus: ResponseStatus<Void> = .idle
    func signOut() async {
        print("[AUTH] Attempting sign out, current user ID: \(userId?.uuidString ?? "unknown")")
        signOutStatus = .loading
        do {
            try await supabase.auth.signOut()
            print("[AUTH] Sign out successful")
            signOutStatus = .success(())
        } catch {
            print("[AUTH] Sign out failed: \(error)")
            signOutStatus = .error(error)
        }
    }

    var sendPasswordResetEmailStatus: ResponseStatus<Void> = .idle
    func sendPasswordResetEmail(to email: String) async {
        print("[AUTH] Sending password reset email to: \(email)")
        sendPasswordResetEmailStatus = .loading
        do {
            try await supabase.auth.resetPasswordForEmail(email)
            print("[AUTH] Password reset email sent successfully to: \(email)")
            sendPasswordResetEmailStatus = .success(())
        } catch {
            print("[AUTH] Failed to send password reset email to \(email): \(error)")
            sendPasswordResetEmailStatus = .error(error)
        }
    }

    var fetchUserStatus: ResponseStatus<Supabase.User> = .idle
    func fetchUser(onSuccess: (() -> Void)? = nil) async {
        print("[AUTH] Fetching current user")
        fetchUserStatus = .loading
        do {
            let user = try await supabase.auth.user()
            isOnboardingCompleted = parseOnboardingCompletedFromUserMeta(
                user: user)
            isAuthenticated = user.isAnonymous == false
            print("[AUTH] User fetched successfully. ID: \(user.id.uuidString)")
            fetchUserStatus = .success(user)
            onSuccess?()
        } catch {
            print("[AUTH] Failed to fetch user: \(error)")
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
                print("[AUTH] Legacy user detected (no onboarding_completed in metadata)")
                return true
            }

            if let boolValue = try user?.userMetadata[
                "onboarding_completed"]?.decode(as: Bool.self)
            {
                print("[AUTH] Onboarding value (bool): \(boolValue)")
                return boolValue
            }
            if let stringValue = try user?.userMetadata[
                "onboarding_completed"]?.decode(as: String.self)
            {
                let result = stringValue.lowercased() == "true"
                print("[AUTH] Onboarding value (string): \(stringValue), converted to: \(result)")
                return result
            }

            print("[AUTH] No valid onboarding_completed value found")
            return false
        } catch {
            print("[AUTH] Error parsing onboarding_completed: \(error)")
            return false
        }
    }
}

extension AuthStore {
    func refreshSession() async {
        print("[AUTH] Attempting to refresh session")
        do {
            let session = try await supabase.auth.refreshSession()
            let expiresAtDate = Date(timeIntervalSince1970: session.expiresAt)
            let expiresIn = expiresAtDate.timeIntervalSinceNow
            print("[AUTH] Session refreshed successfully. Expires in: \(Int(expiresIn)) seconds")
            scheduleSessionRefresh(after: expiresIn - 60)
        } catch {
            print("[AUTH] Session refresh failed: \(error)")
        }
    }

    private func scheduleSessionRefresh(after interval: TimeInterval) {
        print("[AUTH] Scheduling session refresh after \(Int(interval)) seconds")
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(
                withTimeInterval: max(interval, 0), repeats: false
            ) { _ in
                Task {
                    print("[AUTH] Executing scheduled session refresh")
                    await self.refreshSession()
                }
            }
        }
    }
}
