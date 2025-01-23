//
//  NavigationService.swift
//  trailhead
//
//  Created by Robin Götz on 1/22/25.
//
import Observation
import SwiftUI

enum AppNavigationPath: Hashable {
    case onBoarding(OnboardingPath)

    enum OnboardingPath: Hashable {
        case welcome
        case userConsent
        case phoneSignUp(PhoneSignUpPath)
        case userOnboarding(UserOnboardingPath)
        case personalityOnboarding(PersonalityPath)
        case oneMoreThing

        enum PhoneSignUpPath: Hashable {
            case enterNumber
            case verifyCode
            case success
        }

        enum UserOnboardingPath: Hashable {
            case name
            case pronouns
            case birthday
        }

        enum PersonalityPath: Hashable, CaseIterable {
            case intro
            case excitedAbout
            case mentorQualities
            case beLikeYou(BeLikeYouPath)
            
            enum BeLikeYouPath: Hashable {
                case overview
                case selectPrompt
                case enterPromptResponse
            }
            
            static var allCases: [AppNavigationPath.OnboardingPath.PersonalityPath] {
                return [.intro, .excitedAbout, .mentorQualities, .beLikeYou(.overview)]
            }
            static var totalCases: Int { allCases.count }
        }
    }
}
@Observable class NavigationService {
    var path = NavigationPath([
        AppNavigationPath.onBoarding(.personalityOnboarding(.intro))
    ])
}
