//
//  UserOnboardingNameView.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import SwiftUI

struct UserOnboardingNameView: View {
    @Environment(UserOnboardingStore.self) private var store
    private var isNameEmpty: Bool {
        return self.store.name.isEmpty
    }
    
    private let onBack: () -> Void
    private let onContinue: () -> Void
    
    init(
        onBack: @escaping () -> Void,
        onContinue: @escaping () -> Void) {
        self.onBack = onBack
        self.onContinue = onContinue
    }

    var body: some View {
        @Bindable var store = self.store
        UserOnboardingWrapperView(title: "What's your first name?", subtitle: "This will be the name Sam uses to refer to you.", isContinueDisabled: self.isNameEmpty) {
            TextField("e.g. Catie", text: $store.name)
                .placeholder(when: self.isNameEmpty) {
                    Text("e.g. Catie")
                        .opacity(0.6)
                }
                .frame(maxWidth: .infinity)
                .inputStyle()
        } onBack: {
            self.onBack()
        } onContinue: {
            self.onContinue()
        }
    }
}

#Preview {
    UserOnboardingNameView(onBack: {}, onContinue: {}).environment(UserOnboardingStore())
}
