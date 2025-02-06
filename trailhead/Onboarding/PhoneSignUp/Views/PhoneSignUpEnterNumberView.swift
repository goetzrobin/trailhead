//
//  PhoneSignUpEnterNumber.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//

import SwiftUI
import Observation

struct PhoneSignUpEnterNumberView: View {
    @Environment(PhoneSignUpStore.self) private var store

    var body: some View {
        @Bindable var store = self.store
        VStack {
            Text(
                "So we'll send a code to your phone to verify your account! That's it. Super easy! We'll never share your number with outsiders."
            )
            .padding(.bottom, 40)
            PhoneSignUpEnterNumberInputView(
                currentCountryCode: $store.currentCountryCode,
                phoneNumber: $store.phoneNumber
            )
                .frame(height: 80)
            Spacer()
            HStack {
                Spacer()
                ContinueButton(label: "Send code to my phone number") {
                    self.store.sendCode()
                }
                .disabled(self.store.phoneNumber.isEmpty)
            }

        }
        .frame(minHeight: 0, maxHeight: .infinity)
    }
}

#Preview {
    PhoneSignUpEnterNumberView().environment(PhoneSignUpStore())
}
