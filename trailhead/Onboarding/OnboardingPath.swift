//
//  OnboardingRouter.swift
//  trailhead
//
//  Created by Robin Götz on 1/24/25.
//

import Observation
import SwiftUI

enum OnboardingPath: Hashable {
    //         empty -> welcome
    case userConsent
    case phoneSignUp
    case userOnboarding
    case personalityOnboarding
    case oneMoreThing
}
