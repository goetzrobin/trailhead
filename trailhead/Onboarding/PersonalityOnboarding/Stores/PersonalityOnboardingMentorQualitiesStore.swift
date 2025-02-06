//
//  PersonalityOnboardingExcitedAboutStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/29/25.
//
import Foundation
import Observation
import SwiftUI

@Observable class PersonalityOnboardingMentorQualitiesStore {
    let maxSelectableMentorQualities = 3
    private(set) var selectedMentorQualities: [MentorQuality] = []
    func selectQuality(_ quality: MentorQuality) {
        if selectedMentorQualities.count
            >= self.maxSelectableMentorQualities
        {
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
