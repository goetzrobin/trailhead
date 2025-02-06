import Observation
//
//  PersonalityOnbaordingBeLikeYouStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/29/25.
//
import SwiftUI

struct PromptDraft {
    var option: PromptOption?
    var response: String

    var isComplete: Bool {
        option != nil && !response.isEmpty
    }
}

@Observable class PersonalityOnboardingBeLikeYouStore {
    // MARK: - Constants
    let maxCharsAllowed = 160
    let requiredResponseCount = 3

    // MARK: - State
    private(set) var promptResponses: [PromptOptionAndResponse?]
    private(set) var currentIndex: Int
    private(set) var currentDraft: PromptDraft?
    private(set) var isUpdatingExistingResponse: Bool

    // MARK: - Computed Properties
    var respondedToResponsesCount: Int {
        promptResponses.filter { $0 != nil }.count
    }

    var hasAllRequiredResponses: Bool {
        respondedToResponsesCount == requiredResponseCount
    }

    var currentResponseDraftBinding: Binding<String>? {
        guard currentDraft != nil else { return nil }

        return Binding(
            get: { self.currentDraft?.response ?? "" },
            set: { newValue in
                if newValue.count <= self.maxCharsAllowed {
                    self.updateDraftResponse(newValue)
                }
            }
        )
    }

    // MARK: - Initialization
    init() {
        self.promptResponses = Array(repeating: nil, count: 3)
        self.currentIndex = 0
        self.isUpdatingExistingResponse = false
    }

    // MARK: - Flow Management

    func startNewResponse(at index: Int) {
        guard index >= 0 && index < promptResponses.count else { return }
        currentIndex = index
        isUpdatingExistingResponse = false
        currentDraft = PromptDraft(option: nil, response: "")
    }

    func startUpdatingResponse(at index: Int) {
        guard index >= 0 && index < promptResponses.count,
            let existingResponse = promptResponses[index]
        else { return }

        currentIndex = index
        isUpdatingExistingResponse = true
        currentDraft = PromptDraft(
            option: existingResponse.option,
            response: existingResponse.response
        )
        print("Is updating \(isUpdatingExistingResponse) \(String(describing: currentDraft))")
    }

    // MARK: - Draft Management

    private func updateDraftResponse(_ response: String) {
        guard var draft = currentDraft,
            response.count <= maxCharsAllowed
        else { return }

        draft.response = response
        currentDraft = draft
    }

    func selectPrompt(_ prompt: PromptOption) {
        guard var draft = currentDraft else { return }
        draft.option = prompt
        currentDraft = draft
    }

    func commitCurrentDraft() {
        guard let draft = currentDraft,
            let option = draft.option
        else { return }

        let response = PromptOptionAndResponse(
            option: option,
            response: draft.response
        )

        promptResponses[currentIndex] = response
        currentDraft = nil
        isUpdatingExistingResponse = false
    }

    func discardDraft() {
        currentDraft = nil
        isUpdatingExistingResponse = false
    }
}
