//
//  PersonalityOnboardingExcitedAboutStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/29/25.
//
import Foundation
import Observation
import SwiftUI

@Observable class PersonalityOnboardingExcitedAboutStore {
    let maxSelectableInterests = 10
    private(set) var selectedInterests: [UserInterest] = []
    

    func selectInterest(_ interest: UserInterest) {
        if selectedInterests.count >= self.maxSelectableInterests {
            return
        }
        if !selectedInterests.contains(interest) {
            selectedInterests.append(interest)
        }
    }
    
    func deselectInterest(_ interest: UserInterest) {
        if let index = selectedInterests.firstIndex(of: interest) {
            selectedInterests.remove(at: index)
        }
    }
}
