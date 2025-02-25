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
    let onOnboardingComplete: () -> Void

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
                        onFlowComplete: {
                            self.router.path.append(
                                OnboardingPath
                                    .oneMoreThing
                            )
                        }
                    )
                    .navigationBarBackButtonHidden()

                case .oneMoreThing:
                    OneMoreThingView {
                        onOnboardingComplete()
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingView(showingAuth: .constant(false), auth: AuthStore()) {
        print("onboarding completed")
    }
}
