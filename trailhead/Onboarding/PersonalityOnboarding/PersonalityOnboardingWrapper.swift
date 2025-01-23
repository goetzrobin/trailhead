//
//  PersonalityOnboardingWrapper.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct PersonalityOnboardingWrapper<Content: View>: View {
    let onBack: () -> Void
    let onSkip: (() -> Void)?
    let content: () -> Content

    init(
        onBack: @escaping () -> Void, onSkip: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.onBack = onBack
        self.onSkip = onSkip
        self.content = content
    }

    var body: some View {
        VStack {
            content()
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Back button
                Button(action: onBack) {
                    Label("Back", systemImage: "chevron.left")
                        .font(.system(size: 15))
                        .labelStyle(.iconOnly)
                        .padding(5)
                }
                .buttonStyle(.plain)
            }

            ToolbarItem(placement: .principal) {
                PersonalityOnboardingWrapperProgressIndicatorView()
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                // Exit button
                Button(action: { self.onSkip?() }) {
                    Text("Skip")
                        .font(.system(size: 15))
                        .labelStyle(.iconOnly)
                        .padding(5)
                }
                .disabled(self.onSkip == nil)
                .opacity(self.onSkip == nil ? 0 : 1)
                .buttonStyle(.plain)
            }
        }
        .navigationBarBackButtonHidden()
    }

}

#Preview {
    PersonalityOnboardingWrapper(onBack: {
        print("back")
    }) {
        Text("Hello world")
    }.environment(PersonalityOnboardingStore())
}
