//
//  Onboarding.swift
//  trailhead
//
//  Created by Robin Götz on 1/13/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(NavigationService.self) var nav
    @State var isUserConsentGiven = false

    @State var phoneSignUpStore = PhoneSignUpStore()
    func setupPhoneSignUpStoreCallbacks() {
        self.phoneSignUpStore.setupCallbacks(
            onCodeSent: {
                self.nav.path.append(
                    AppNavigationPath.onBoarding(.phoneSignUp(.verifyCode))
                )
            },
            onCodeVerified: {
                self.nav.path.append(
                    AppNavigationPath.onBoarding(.phoneSignUp(.success))
                )
            }
        )
    }

    @State var userOnboardingStore = UserOnboardingStore()
    func setupUserOnboardingStoreCallbacks() {
        print("bla")
    }

    @State var personalityOnboardingStore = PersonalityOnboardingStore()

    var body: some View {
        @Bindable var nav = self.nav
        NavigationStack(path: $nav.path) {
            WelcomeView {
                if !self.isUserConsentGiven {
                    self.nav.path.append(
                        AppNavigationPath.onBoarding(.userConsent))
                    return
                }
                if !self.phoneSignUpStore.codeVerified {
                    self.nav.path.append(
                        AppNavigationPath.onBoarding(
                            .phoneSignUp(.enterNumber)))
                    return
                }
                self.nav.path.append(
                    AppNavigationPath.onBoarding(.userOnboarding(.name))
                )
            }
            .navigationDestination(for: AppNavigationPath.self) { currentStep in
                switch currentStep {
                case AppNavigationPath.onBoarding(.userConsent):
                    UserConsentView {
                        self.isUserConsentGiven = true
                        self.nav.path.append(
                            AppNavigationPath.onBoarding(
                                .phoneSignUp(.enterNumber)))
                    }
                    .navigationBarBackButtonHidden()
                case AppNavigationPath.onBoarding(
                    .phoneSignUp(.enterNumber)):
                    PhoneSignUpWrapperView(
                        title: "Nobody likes reading their emails..."
                    ) {
                        PhoneSignUpEnterNumberView()
                    } onExit: {
                        self.nav.path = NavigationPath()
                    }
                case AppNavigationPath.onBoarding(
                    .phoneSignUp(.verifyCode)):
                    PhoneSignUpWrapperView(
                        title: "Did you get your code? Enter it here!"
                    ) {
                        PhoneSignUpConfirmCodeView()
                    } onExit: {
                        self.nav.path = NavigationPath()
                    } onBack: {
                        self.nav.path.removeLast()

                    }
                case AppNavigationPath.onBoarding(.phoneSignUp(.success)):
                    PhoneSignUpSuccessView {
                        self.nav.path.append(
                            AppNavigationPath.onBoarding(
                                .userOnboarding(.name))
                        )
                    }
                    .navigationBarBackButtonHidden()

                case AppNavigationPath.onBoarding(
                    .userOnboarding(.name)):
                    UserOnboardingNameView(
                        onBack: {
                            self.nav.path = NavigationPath()
                        },
                        onContinue: {
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(
                                    .userOnboarding(.pronouns))
                            )
                        })

                case AppNavigationPath.onBoarding(
                    .userOnboarding(.pronouns)):
                    UserOnboardingPronounsView(
                        onBack: {
                            self.nav.path.removeLast()
                        },
                        onSkip: {
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(
                                    .userOnboarding(.birthday))
                            )
                        },
                        onContinue: {
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(
                                    .userOnboarding(.birthday))
                            )
                        }
                    )

                case AppNavigationPath.onBoarding(
                    .userOnboarding(.birthday)):
                    UserOnboardingBirthdayView(
                        onBack: {
                            self.nav.path.removeLast()
                        },
                        onSkip: {
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(
                                    .personalityOnboarding(.intro))
                            )
                        },
                        onContinue: {
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(
                                    .personalityOnboarding(.intro))
                            )
                        }
                    )

                case AppNavigationPath.onBoarding(
                    .personalityOnboarding(.intro)):
                    PersonalityOnboardingIntroView {
                        self.personalityOnboardingStore.updateCurrentPath(
                            .excitedAbout)
                        self.nav.path.append(
                            AppNavigationPath.onBoarding(
                                .personalityOnboarding(.excitedAbout)))
                    }
                    .navigationBarBackButtonHidden()

                case AppNavigationPath.onBoarding(
                    .personalityOnboarding(.excitedAbout)):
                    PersonalityOnboardingExcitedAboutView(
                        onBack: {
                            self.personalityOnboardingStore.updateCurrentPath(
                                .intro)
                            self.nav.path.removeLast()
                        },
                        onSkip: {
                            self.personalityOnboardingStore.updateCurrentPath(
                                .mentorQualities)
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(
                                    .personalityOnboarding(
                                        .mentorQualities)))
                        },
                        onContinue: {
                            self.personalityOnboardingStore.updateCurrentPath(
                                .mentorQualities)
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(
                                    .personalityOnboarding(
                                        .mentorQualities)))
                        }
                    )

                case AppNavigationPath.onBoarding(
                    .personalityOnboarding(.mentorQualities)):
                    PersonalityOnboardingMentorQualitiesView(
                        onBack: {
                            self.personalityOnboardingStore.updateCurrentPath(
                                .excitedAbout)
                            self.nav.path.removeLast()
                        },
                        onSkip: {
                            self.personalityOnboardingStore.updateCurrentPath(
                                .beLikeYou(.overview))
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(
                                    .personalityOnboarding(
                                        .beLikeYou(.overview))))
                        },
                        onContinue: {
                            self.personalityOnboardingStore.updateCurrentPath(
                                .beLikeYou(.overview))
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(
                                    .personalityOnboarding(
                                        .beLikeYou(.overview))))

                        }
                    )

                case AppNavigationPath.onBoarding(
                    .personalityOnboarding(.beLikeYou(.overview))):
                    PersonalityOnboardingBeLikeYouView(
                        onBack: {
                            self.personalityOnboardingStore.updateCurrentPath(
                                .mentorQualities)
                            self.nav.path.removeLast()
                        },
                        onSkip: {
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(.oneMoreThing))
                        },
                        onContinue: {
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(.oneMoreThing))
                        }
                    )
                case AppNavigationPath.onBoarding(
                    .oneMoreThing
                ):
                    OneMoreThingView {
                        self.nav.path.append(
                            AppNavigationPath.onBoarding(.welcome))
                    }

                default:
                    EmptyView()
                }
            }
        }

        .environment(self.phoneSignUpStore)
        .environment(self.userOnboardingStore)
        .environment(self.personalityOnboardingStore)
        .onAppear {
            self.setupPhoneSignUpStoreCallbacks()
            self.setupUserOnboardingStoreCallbacks()
        }
    }
}

#Preview {
    OnboardingView()
        .environment(NavigationService())
}
