//
//  PersonalityOnboardingExcitedAboutStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/29/25.
//
import Foundation
import Observation
import SwiftUI

@Observable class PersonalityOnboardingMentorTraitsStore {
    let maxSelectableMentorTraits = 3
    private(set) var selectedMentorTraits: [UserMentorTrait] = []
    func selectTrait(_ trait: UserMentorTrait) {
        if selectedMentorTraits.count
            >= self.maxSelectableMentorTraits
        {
            return
        }
        if !selectedMentorTraits.contains(trait) {
            selectedMentorTraits.append(trait)
        }
    }
    func deselectTrait(_ trait: UserMentorTrait) {
        if let index = selectedMentorTraits.firstIndex(of: trait) {
            selectedMentorTraits.remove(at: index)
        }
    }
}
