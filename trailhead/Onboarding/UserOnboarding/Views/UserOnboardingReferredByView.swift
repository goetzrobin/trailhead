//
//  UserOnboardingNameView.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import SwiftUI

struct UserOnboardingReferredByView: View {
    @Environment(UserOnboardingStore.self) private var store
    private var isReferredByEmpty: Bool {
        return self.store.referredBy.isEmpty
    }
    
    private let onBack: () -> Void
    private let onSkip: () -> Void
    private let onContinue: () -> Void
    
    init(
        onBack: @escaping () -> Void,
        onSkip: @escaping () -> Void,
        onContinue: @escaping () -> Void) {
        self.onBack = onBack
        self.onSkip = onSkip
        self.onContinue = onContinue
    }

    var body: some View {
        @Bindable var store = self.store
        UserOnboardingWrapperView(title: "Who referred you?", subtitle: "Please make sure to enter both their name and the sport.", isContinueDisabled: false) {
            TextField("e.g. Sam Doe, Volleyball", text: $store.referredBy)
                .placeholder(when: self.isReferredByEmpty) {
                    Text("e.g. Sam Doe, Volleyball")
                        .opacity(0.6)
                }
                .frame(maxWidth: .infinity)
                .inputStyle()
        }
        onBack: {
            self.onBack()
        } onContinue: {
            self.onContinue()
        } onSkip: {
            self.onSkip()
        }
    }
}

#Preview {
    NavigationStack {
        UserOnboardingNameView(onBack: {}, onContinue: {}).environment(UserOnboardingStore())
    }
}
