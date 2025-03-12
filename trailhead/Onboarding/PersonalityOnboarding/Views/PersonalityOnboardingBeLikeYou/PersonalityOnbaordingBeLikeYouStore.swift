//
//  PersonalityOnbaordingBeLikeYouStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/29/25.
//
import SwiftUI
import Observation

let PROMPT_RESPONSES = [
    PromptOptionAndResponse(option: PromptOption(id: UUID(uuidString: "7c64f8f6-1ed0-4449-90fa-f9c7df7adfc1")!, prompt: "When you think about your life after college (athletics), what excites you the most? What worries you the most?"), response: nil),
    PromptOptionAndResponse(option: PromptOption(id: UUID(uuidString: "b689222f-e43b-4430-999f-17e1e2fc1c7c")!, prompt: "Have you received any formal support or guidance about preparing for this transition? If so, what was it, and was it helpful?"), response: nil),
    PromptOptionAndResponse(option: PromptOption(id: UUID(uuidString: "e5e8eabd-a988-4bbb-aee1-2cb42f86167c")!, prompt: "Many athletes experience a shift in their identity when they leave their sport. How would you describe your identity now, and how do you think it will change when you’re no longer competing?"), response: nil),
    PromptOptionAndResponse(option: PromptOption(id: UUID(uuidString: "2c562b23-6672-4aee-a4e0-c0e3665fd29a")!, prompt: "Beyond your sport, how would you describe your confidence in other areas of your life—such as career planning, networking, or developing new skills?"), response: nil),
    PromptOptionAndResponse(option: PromptOption(id: UUID(uuidString: "427680e5-a17c-460a-b4ff-a4b260be23ab")!, prompt: "When facing challenges—whether in sports, school, or life—who do you typically turn to for advice or support?"), response: nil),
    PromptOptionAndResponse(option: PromptOption(id: UUID(uuidString: "a11805d8-7981-48b6-8f42-2aaeb753c085")!, prompt: "Can you think of a time when you successfully adapted to a big life change? What helped you navigate that transition?"), response: nil),
    PromptOptionAndResponse(option: PromptOption(id: UUID(uuidString: "e26615e6-2122-426c-b8a2-d695faa3f4fa")!, prompt: "If you could design the perfect transition support system, what would it include?"), response: nil),
    PromptOptionAndResponse(option: PromptOption(id: UUID(uuidString: "46ee672d-0f19-4f72-945a-4f57a2b5d610")!, prompt: "A year from now, what would ‘success’ look like for you in terms of your transition from college sports?"), response: nil),
]

@Observable class PersonalityOnboardingBeLikeYouStore {
    // Keep your data - no change to array structure
    var promptResponses: [PromptOptionAndResponse] = PROMPT_RESPONSES
    
    // Single state for editing - much simpler than before
    var editingIndex: Int?
    
    // Keep max chars as constant
    let maxCharsAllowed = 320
    
    // Computed vars for UI
    var isEditing: Bool {
        return editingIndex != nil
    }
    
    var hasAllResponses: Bool {
        return promptResponses.allSatisfy { !$0.isEmpty }
    }
    
    // Count completed responses for progress
    var completedResponsesCount: Int {
        return promptResponses.filter { !$0.isEmpty }.count
    }
    
    // For text field binding - simpler version
    var responseTextBinding: Binding<String>? {
        guard let index = editingIndex else { return nil }
        
        return Binding(
            get: { self.promptResponses[index].response ?? "" },
            set: { newValue in
                if newValue.count <= self.maxCharsAllowed {
                    self.promptResponses[index].response = newValue
                }
            }
        )
    }
    
    var currentPrompt: String {
        print("Index of current prompt: \(self.editingIndex)")
       return self.editingIndex != nil ? self.promptResponses[self.editingIndex!].option.prompt : "\(self.editingIndex)"
    }
    
    // Simple actions
    func startEditing(at index: Int) {
        print("index is about to be updated")
        editingIndex = index
        print("index is updated to \(editingIndex)")
    }
    
    func finishEditing() {
        // Save only if response not empty
        if let index = editingIndex,
           let response = promptResponses[index].response,
           !response.isEmpty {
            // Response already saved through binding
            editingIndex = nil
        }
    }
    
    func cancelEditing() {
        editingIndex = nil
    }
}
