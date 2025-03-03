//
//  PersonalityOnboardingExcitedAboutView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct PersonalityOnboardingExcitedAboutView: View {
    @Environment(PersonalityOnboardingExcitedAboutStore.self) private var store
    let currentStepProgress: CGFloat
    let onBack: () -> Void
    let onSkip: () -> Void
    let onContinue: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PersonalityOnboardingWrapper(
                progress: self.currentStepProgress,
                onBack: { self.onBack() }, onSkip: { self.onSkip() }
            ) {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("What are you excited about?")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, 20)
                            .padding(.bottom, -10)
                        VStack(alignment: .leading) {
                            Text(
                                "My selection \(self.store.selectedInterests.count)/\(self.store.maxSelectableInterests)"
                            )
                            .font(.title3)
                            .bold()
                            SelectionPlaceholdersView(
                                selectedInterests: self.store
                                    .selectedInterests
                            ) {
                                interest in
                                self.store.deselectInterest(interest)
                            }
                            .padding(.bottom)
                        }
                        .padding(.top, 20)
                        .background(.background)
                        .sticky()
                        SelectionSectionsView()
                    }
                }
                .useStickyHeaders()
            }
            ContinueButton(
                label: "Confirm collection and continue to next step"
            ) { self.onContinue() }
                .disabled(store.selectedInterests.isEmpty)
            .padding()
            .offset(y: store.selectedInterests.isEmpty ? 100 : 0)
            .animation(
                .spring(duration: 0.5),
                value: store.selectedInterests.isEmpty)
        }
    }

}

#Preview {
    NavigationStack {
        PersonalityOnboardingExcitedAboutView(
            currentStepProgress: 0.8,
            onBack: { print("back") }, onSkip: { print("skip") },
            onContinue: { print("continue") }
        ).environment(PersonalityOnboardingExcitedAboutStore())
    }
}
