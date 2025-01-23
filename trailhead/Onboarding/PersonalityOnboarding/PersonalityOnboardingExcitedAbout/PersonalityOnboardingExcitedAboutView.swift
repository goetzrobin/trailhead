//
//  PersonalityOnboardingExcitedAboutView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct PersonalityOnboardingExcitedAboutView: View {
    @Environment(PersonalityOnboardingStore.self) private var store
    let onBack: () -> Void
    let onSkip: () -> Void
    let onContinue: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PersonalityOnboardingWrapper(
                onBack: {self.onBack() }, onSkip: {self.onSkip() }
            ) {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("What are you excited about?")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 20)
                        Text(
                            "My selection \(self.store.selectedExcitedAboutOptions.count)/\(self.store.maxSelectableExcitedAboutOptions)"
                        )
                        .font(.title3)
                        SelectionPlaceholdersView(
                            selectedOptions: self.store
                                .selectedExcitedAboutOptions
                        ) {
                            option in
                            self.store.deselectOption(option)
                        }
                        .padding(.bottom)
                        SelectionSectionsView()
                    }
                }
            }
            Button(action: {
                self.onContinue()
            }) {
                Label(
                    "Confirm collection and continue to next step",
                    systemImage: "chevron.right"
                )
                .font(.system(size: 25))
                .labelStyle(.iconOnly)
                .padding(5)
            }.buttonStyle(.borderedProminent)
                .disabled(store.selectedExcitedAboutOptions.isEmpty)
                .padding()
                .offset(y: store.selectedExcitedAboutOptions.isEmpty ? 100 : 0)
                .animation(
                    .spring(duration: 0.5),
                    value: store.selectedExcitedAboutOptions.isEmpty)
        }
    }
    
}

#Preview {
    NavigationStack {
        PersonalityOnboardingExcitedAboutView(
            onBack: { print("back") }, onSkip: { print("skip") },
            onContinue: { print("continue") }
        ).environment(PersonalityOnboardingStore())
    }
}
