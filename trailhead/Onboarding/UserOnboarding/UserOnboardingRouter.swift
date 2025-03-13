//
//  UserOnboardingRouter.swift
//  trailhead
//
//  Created by Robin Götz on 1/24/25.
//
import Observation
import SwiftUI

enum UserOnboardingPath: Hashable {
    //      initial -> name
    case pronouns
    case birthday
    case ethnicity
    case genderIdentity
    case gradYear
    case referredBy
    case cohort
    case competitionLevel
    case submittingInfo
}
