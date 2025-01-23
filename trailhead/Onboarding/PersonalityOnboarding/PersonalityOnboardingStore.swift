//
//  PersonalityOnboardingStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//
import Foundation
import Observation
import SwiftUI

@Observable class PersonalityOnboardingStore {
    let maxSteps: Int = AppNavigationPath.OnboardingPath.PersonalityPath
        .totalCases
    private(set) var currentPath:
        AppNavigationPath.OnboardingPath.PersonalityPath?
    var currentStep: Int {
        guard let currentPath else { return 0 }
        return
            (AppNavigationPath.OnboardingPath.PersonalityPath
            .allCases.firstIndex(of: currentPath) ?? 0) + 1
    }
    func updateCurrentPath(
        _ path: AppNavigationPath.OnboardingPath.PersonalityPath
    ) {
        self.currentPath = path
    }

    let maxSelectableExcitedAboutOptions = 10
    private(set) var selectedExcitedAboutOptions: [ExcitedAboutOption] = []

    func selectOption(_ option: ExcitedAboutOption) {
        if selectedExcitedAboutOptions.count
            >= self.maxSelectableExcitedAboutOptions
        {
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

    let maxCharsAllowed = 160
    private(set) var currentlyRespondingToPromptIndex = 0

    private(set) var currentPromptResponseDraft: PromptOptionAndResponse?
    private(set) var currentPromptResponseDraftBinding: Binding<String>?

    private(set) var promptResponses: [PromptOptionAndResponse?] = [
        nil, nil, nil,
    ]
    func setCurrentlyRespondingToIndex(_ index: Int) {
        if index >= self.promptResponses.count || index < 0 {
            return
        }
        self.currentlyRespondingToPromptIndex = index
    }
    func createNewPromptResponseDraft(_ option: PromptOption, response: String? = nil) {
        self.currentPromptResponseDraft = PromptOptionAndResponse(
            option: option, response: response ?? "")
        self.currentPromptResponseDraftBinding = Binding(
            get: {
                return self.currentPromptResponseDraft?.response ?? ""
            },
            set: {
                if $0.count > self.maxCharsAllowed {
                    return
                }
                self.currentPromptResponseDraft?.response = $0
            })
        print("successfully created new draft: \(self.currentPromptResponseDraft)")
    }
    func discardCurrentPromptResponseDraft() {
        self.currentPromptResponseDraft = nil
    }
    func commitCurrentPromptResponseDraft() {
        if let draft = self.currentPromptResponseDraft {
            self.promptResponses[self.currentlyRespondingToPromptIndex] = draft
        }
        self.currentPromptResponseDraft = nil
    }
}

struct PromptOptionAndResponse {
    var option: PromptOption?
    var response: String
}
