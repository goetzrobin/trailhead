//
//  UserOnboardingPronounsView.swift
//  trailhead
//
//  Created by Robin Götz on 1/16/25.
//

import SwiftUI

struct UserOnboardingPronounsView: View {
    @Environment(UserOnboardingStore.self) private var store
    private var isPronounsEmpty: Bool {
        return self.store.pronouns.isEmpty
    }

    private let onBack: () -> Void
    private let onContinue: () -> Void
    private let onSkip: (() -> Void)?

    init(
        onBack: @escaping () -> Void,
        onSkip: (() -> Void)? = nil,
        onContinue: @escaping () -> Void
    ) {
        self.onBack = onBack
        self.onSkip = onSkip
        self.onContinue = onContinue
    }

    var body: some View {
        @Bindable var store = self.store
        UserOnboardingWrapperView(
            title: "What are your pronouns?",
            subtitle:
                "Specifying your pronouns helps Sam accurately understand your identity",
            isContinueDisabled: self.isPronounsEmpty
        ) {
            TextField("e.g. she/her", text: $store.pronouns)
                .placeholder(when: self.isPronounsEmpty) {
                    Text("e.g. she/her")
                        .opacity(0.6)
                }
                .frame(maxWidth: .infinity)
                .inputStyle()

        } onBack: {
            self.onBack()
        } onContinue: {
            self.onContinue()
        } onSkip: {
            self.onSkip?()
        }

    }
}

#Preview {
    UserOnboardingPronounsView(onBack: {}, onSkip: {}, onContinue: {})
        .environment(
            UserOnboardingStore())
}
