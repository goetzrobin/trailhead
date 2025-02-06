//
//  PhoneSignUpEnterNumber.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//

import Observation
import SwiftUI

let INITIAL_TIME = 59
struct PhoneSignUpConfirmCodeView: View {
    @Environment(PhoneSignUpStore.self) private var store
    @State private var timeRemaining = INITIAL_TIME

    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        @Bindable var store = self.store
        VStack(alignment: .leading) {
            Text("A code was sent to \(self.store.unformattedPhoneNumber).")
                .padding(.bottom, 40)
            TextField("", text: $store.confirmationCode)
                .placeholder(when: self.store.confirmationCode.isEmpty) {
                    Text("Code received").opacity(0.6)
                }
                .keyboardType(.numberPad)
                .inputStyle()
                .padding(.bottom, 10)
            PhoneSignUpConfirmCodeResendView(
                phoneNumber: self.store.unformattedPhoneNumber,
                timeRemaining: self.timeRemaining
            ) {
                self.store.resendCode()
            }
            Spacer()
            HStack {
                Spacer()
                ContinueButton(label: "Verify code entered") {
                    self.store.verifyCode()
                }
                .disabled(self.store.confirmationCode.isEmpty)
            }
        }
        .frame(minHeight: 0, maxHeight: .infinity)
        .onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }

}

#Preview {
    PhoneSignUpConfirmCodeView().environment(PhoneSignUpStore())
}
