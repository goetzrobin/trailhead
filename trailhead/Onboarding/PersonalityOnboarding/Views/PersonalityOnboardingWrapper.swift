//
//  PersonalityOnboardingWrapper.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct PersonalityOnboardingWrapper<Content: View>: View {
    let progress: CGFloat
    let onBack: () -> Void
    let onSkip: (() -> Void)?
    let content: () -> Content

    init(
        progress: CGFloat,
        onBack: @escaping () -> Void, onSkip: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.progress = progress
        self.onBack = onBack
        self.onSkip = onSkip
        self.content = content
    }

    var body: some View {
        VStack {
            content()
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: onBack) {
                    Label("Back", systemImage: "chevron.left")
                        .navigationLabelStyle()
                }
                .buttonStyle(.plain)
            }

            ToolbarItem(placement: .navigation) {
                HStack(alignment: .center) {
                    ProgressView(value: self.progress)
                        .progressViewStyle(.linear)
                        .frame(width: 100)
                        .tint(.primary)
                }
                .frame(width: 900)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                // Exit button
                Button(action: { self.onSkip?() }) {
                    Text("Skip")
                        .navigationLabelStyle(.titleOnly)
                }
                .disabled(self.onSkip == nil)
                .opacity(self.onSkip == nil ? 0 : 1)
                .buttonStyle(.plain)
            }
        }
        .toolbarBackground(.background, for: .navigationBar)
        .navigationBarBackButtonHidden()
    }

}

#Preview {
    PersonalityOnboardingWrapper(progress: 0.5, onBack: {
        print("back")
    }) {
        Text("Hello world")
    }
}
