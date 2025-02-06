//
//  Onboarding.swift
//  trailhead
//
//  Created by Robin Götz on 1/13/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(AppRouter.self) var router
    @State private var isUserConsentGiven = false
    @State private var isCodeVerified = false

    var body: some View {
        @Bindable var router = self.router
        NavigationStack(path: $router.path) {
            WelcomeView {
                if !self.isUserConsentGiven {
                    self.router.path.append(
                        OnboardingPath.userConsent)
                    return
                }
                if !self.isCodeVerified {
                    self.router.path.append(OnboardingPath.phoneSignUp)
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
                            OnboardingPath.phoneSignUp)
                    }
                    .navigationBarBackButtonHidden()

                case .phoneSignUp:
                    PhoneSignUpFlowView(
                        onExit: {
                            self.router.path.removeLast(self.router.path.count)
                        },
                        onCodeVerified: {
                            self.isCodeVerified = true
                        },
                        onFlowComplete: {
                            self.router.path.append(
                                OnboardingPath.userOnboarding
                            )
                        })
                case .userOnboarding:
                    UserOnboardingFlowView(
                        onFlowComplete: {
                            self.router.path.append(
                                OnboardingPath
                                    .personalityOnboarding
                            )
                        })
                        .navigationBarBackButtonHidden()
                case .personalityOnboarding:
                    PersonalityOnboardingFlowView(onFlowComplete: {
                        self.router.path.append(
                            OnboardingPath
                                .oneMoreThing
                        )
                    })
                    .navigationBarBackButtonHidden()

                case .oneMoreThing:
                    OneMoreThingView {
                        self.router.path.removeLast(
                            self.router.path.count)
                    }
                }
            }
            .onChange(of: router.path) { oldValue, newValue in
                print("\(newValue)")
            }
        }
    }
}

#Preview {
    OnboardingView().environment(AppRouter())
}
