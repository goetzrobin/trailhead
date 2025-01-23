//
//  PersonalityOnboardingMentorQualitiesView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct PersonalityOnboardingMentorQualitiesView: View {
    @Environment(PersonalityOnboardingStore.self) private var store
    let onBack: () -> Void
    let onSkip: () -> Void
    let onContinue: () -> Void

    var body: some View {
        PersonalityOnboardingWrapper(
            onBack: {self.onBack() }, onSkip: {self.onSkip() }
        ) {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Tell us what you value in a mentor!")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 10)
                        Text("Everyone needs different things in a guide. Which **three qualities** speak to you?")
                            .padding(.bottom, 20)
                        Text("Their qualities")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 10)
                        MentorQualitySelectView()
                    }
                }
                HStack(alignment: .center) {
                    Text("\(self.store.selectedMentorQualities.count)/\(self.store.maxSelectableMentorQualities) selected")
                    Spacer()
                    Button(action: { self.onContinue() }) {
                        Label(
                            "Confirm collection and continue to next step",
                            systemImage: "chevron.right"
                        )
                        .font(.system(size: 25))
                        .labelStyle(.iconOnly)
                        .padding(5)
                    }.buttonStyle(.borderedProminent)
                        .disabled(self.store.selectedMentorQualities.isEmpty)
                }
            }
        }
    }
}

#Preview {
    PersonalityOnboardingMentorQualitiesView(
        onBack: { print("back") }, onSkip: { print("skip") },
        onContinue: { print("continue") }
    ).environment(PersonalityOnboardingStore())
}
