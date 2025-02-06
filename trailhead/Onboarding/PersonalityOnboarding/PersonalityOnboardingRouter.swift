//
//  PersonalityOnboardingRouter.swift
//  trailhead
//
//  Created by Robin Götz on 1/24/25.
//
import Observation
import SwiftUI

enum PersonalityPath: Hashable, CaseIterable {
    // special case because we need progress indicator
//  initial -> intro
    case excitedAbout
    case mentorQualities
    case beLikeYou

    static var allCases: [PersonalityPath] {
        return [.excitedAbout, .mentorQualities, .beLikeYou]
    }
    static var totalCases: Int { allCases.count }
}
