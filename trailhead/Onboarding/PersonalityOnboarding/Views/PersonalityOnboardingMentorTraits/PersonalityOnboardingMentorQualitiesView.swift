//
//  PersonalityOnboardingMentorQualitiesView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct PersonalityOnboardingMentorQualitiesView: View {
    let store: PersonalityOnboardingMentorTraitsStore
    let currentStepProgress: CGFloat
    let onBack: () -> Void
    let onSkip: () -> Void
    let onContinue: () -> Void

    var body: some View {
        PersonalityOnboardingWrapper(
            progress: self.currentStepProgress,
            onBack: { self.onBack() }, onSkip: { self.onSkip() }
        ) {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Tell us what you value in a mentor!")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 10)
                        Text(
                            "Everyone needs different things in a guide. Which **three qualities** speak to you?"
                        )
                        .padding(.bottom, 20)
                        Text("Their qualities")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 10)
                        MentorTraitsSelectView(store: store)
                    }
                }
                HStack(alignment: .center) {
                    Text(
                        "\(self.store.selectedMentorTraits.count)/\(self.store.maxSelectableMentorTraits) selected"
                    )
                    Spacer()
                    ContinueButton(
                        label: "Confirm collection and continue to next step"
                    ) {
                        self.onContinue()
                    }.disabled(self.store.selectedMentorTraits.isEmpty)
                }
            }
        }
    }
}

#Preview {
    PersonalityOnboardingMentorQualitiesView(
        store: PersonalityOnboardingMentorTraitsStore(),
        currentStepProgress: 0.5,
        onBack: { print("back") }, onSkip: { print("skip") },
        onContinue: { print("continue") }
    )
}
