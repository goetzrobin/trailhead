//
//  Onboarding.swift
//  trailhead
//
//  Created by Robin Götz on 1/13/25.
//

import SwiftUI

enum OnboardingStep {
    case welcome
    case userConsent
    case finished
    case phoneSignUpEnterNumber
    case phoneSignUpVerifyCode
    case phoneSignUpVerifySuccess
}

struct OnboardingView: View {
    @State var isUserConsentGiven = false
    @State var currentStep: OnboardingStep = .phoneSignUpEnterNumber

    @State var phoneSignUpStore = PhoneSignUpStore()

    var body: some View {
        ZStack {
            switch self.currentStep {
            case .welcome:
                WelcomeView {
                    self.currentStep =
                        !self.isUserConsentGiven
                        ? .userConsent : .phoneSignUpEnterNumber
                }
            case .userConsent:
                UserConsentView {
                    self.isUserConsentGiven = true
                    self.currentStep = .phoneSignUpEnterNumber
                }
            case .phoneSignUpEnterNumber:
                PhoneSignUpWrapperView(
                    title: "Nobody likes reading their emails..."
                ) {
                    PhoneSignUpEnterNumberView()
                } onExit: {
                    self.currentStep = .welcome
                }
            case .phoneSignUpVerifyCode:
                PhoneSignUpWrapperView(
                    title: "Did you get your code? Enter it here!"
                ) {
                    PhoneSignUpConfirmCodeView()
                } onExit: {
                    self.currentStep = .welcome
                }
            default:
                VStack {
                    Button("Start Over") {
                        self.currentStep = .welcome
                    }
                }
            }
        }
        .environment(self.phoneSignUpStore)
        .onAppear() {
            self.phoneSignUpStore.setupCallbacks(onCodeSent: {
                self.currentStep = .phoneSignUpVerifyCode
            }, onCodeVerified: {
                self.currentStep = .phoneSignUpVerifySuccess
            })
        }

    }
}

#Preview {
    OnboardingView()
}
