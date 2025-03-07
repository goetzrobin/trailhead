//
//  Onboarding.swift
//  trailhead
//
//  Created by Robin Götz on 1/13/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showingAuth: Bool

    let auth: AuthStore
    let userApiClient: UserAPIClient
    let onboardingLetterApiClient: OnboardingLetterAPIClient
    let onboardingCompleteApiClient: CompleteOnboardingAPIClient
    let onOnboardingComplete: (_: UUID?) -> Void

    @State var router = AppRouter()
    @State private var isUserConsentGiven = false
    @State private var isSignUpCompleted = false

    var body: some View {
        NavigationStack(path: $router.path) {
            WelcomeView {
                self.showingAuth = true
            } onTap: {
                if !self.isUserConsentGiven {
                    self.router.path.append(
                        OnboardingPath.userConsent)
                    return
                }
                if !self.isSignUpCompleted {
                    self.router.path.append(OnboardingPath.signUp)
                    return
                }
                self.router.path.append(OnboardingPath.userOnboarding)
            }
            .navigationDestination(for: OnboardingPath.self) {
                currentStep in
                switch currentStep {
                case .userConsent:
                    UserConsentView {
                        self.isUserConsentGiven = true
                        self.router.path.append(
                            OnboardingPath.signUp)
                    }
                    .navigationBarBackButtonHidden()

                case .signUp:
                    SignUpFlowView(
                        auth: auth,
                        router: self.router,
                        onExit: {
                            self.router.path.removeLast(self.router.path.count)
                        },
                        onSignUpSuccess: {
                            self.isSignUpCompleted = true
                        },
                        onFlowComplete: {
                            self.router.path.append(
                                OnboardingPath.userOnboarding
                            )
                        })
                case .userOnboarding:
                    UserOnboardingFlowView(
                        router: self.router,
                        userApiClient: self.userApiClient,
                        userId: self.auth.userId,
                        onFlowComplete: {
                            self.router.path.append(
                                OnboardingPath
                                    .personalityOnboarding
                            )
                        }
                    )
                    .navigationBarBackButtonHidden()
                case .personalityOnboarding:
                    PersonalityOnboardingFlowView(
                        router: self.router,
                        userApiClient: self.userApiClient,
                        userID: self.auth.userId,
                        onFlowComplete: {
                            self.router.path.append(
                                OnboardingPath
                                    .notifications
                            )
                        }
                    )
                    .navigationBarBackButtonHidden()
                    
                case .notifications:
                    NotificationsView {
                        self.router.path.append(
                            OnboardingPath
                                .oneMoreThing
                        )
                    }
                        .navigationBarBackButtonHidden()

                case .oneMoreThing:
                    OneMoreThingView(isSubmittingOnboardingLetter: self.onboardingLetterApiClient.submitOnboardingLetterStatus == .loading){ text in
                        if let userId = auth.userId {
                            self.onboardingLetterApiClient
                                .submitOnboardingLetter(for: userId, with: text)
                            { _ in
                                self.router.path.append(
                                    OnboardingPath
                                        .completingOnboarding
                                )
                            }
                        }
                    }
                    .navigationBarBackButtonHidden()

                case .completingOnboarding:
                    CompletingOnboardingView()
                        .onAppear {
                            completeOnboarding()
                        }
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
    func completeOnboarding() {
        if let userId = self.auth.userId {
            self.onboardingCompleteApiClient.completeOnboarding(for: userId, onSuccess:  { profile in
                self.onOnboardingComplete(profile?.sessionLogId)
                })
        }
    }
}

struct CompletingOnboardingView: View {
    var body: some View {
        ProgressView()
            .scaleEffect(2.0)
        Text("Please wait while Sam is reflecting on your letter...")
            .font(.headline)
            .padding(.top, 20)
    }
}

#Preview {
    @Previewable var auth = AuthStore()
    OnboardingView(
        showingAuth: .constant(false),
        auth: auth,
        userApiClient: UserAPIClient(authProvider: auth),
        onboardingLetterApiClient: OnboardingLetterAPIClient(
            authProvider: auth),
        onboardingCompleteApiClient: CompleteOnboardingAPIClient(
            authProvider: auth)
    ) { sessionLogId in
        print("onboarding completed")
    }
}
