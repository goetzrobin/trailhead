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
    let maxSelectableExcitedAboutOptions = 10
    private(set) var selectedExcitedAboutOptions: [ExcitedAboutOption] = []
    
    let maxSelectableMentorQualities = 3
    private(set) var selectedMentorQualities: [MentorQuality] = []
    
    func selectOption(_ option: ExcitedAboutOption) {
        if selectedExcitedAboutOptions.count >= self.maxSelectableExcitedAboutOptions {
            return
        }
        if !selectedExcitedAboutOptions.contains(option) {
            selectedExcitedAboutOptions.append(option)
        }
    }
    
    func deselectOption(_ option: ExcitedAboutOption) {
        if let index = selectedExcitedAboutOptions.firstIndex(of: option) {
            selectedExcitedAboutOptions.remove(at: index)
        }
    }
    
    func selectQuality(_ quality: MentorQuality) {
        if selectedMentorQualities.count >= self.maxSelectableMentorQualities {
            return
        }
        if !selectedMentorQualities.contains(quality) {
            selectedMentorQualities.append(quality)
        }
    }
    
    func deselectQuality(_ quality: MentorQuality) {
        if let index = selectedMentorQualities.firstIndex(of: quality) {
            selectedMentorQualities.remove(at: index)
        }
    }
}
