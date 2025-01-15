//
//  PhoneSignUpEnterNumber.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//

import SwiftUI
import Observation

let INITIAL_TIME = 59
struct PhoneSignUpConfirmCodeView: View {
    @Environment(PhoneSignUpStore.self) private var store
    @State private var timeRemaining = INITIAL_TIME
    
    private var unformattedPhoneNumber: String {
         store.phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
     }
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        @Bindable var store = self.store
        VStack(alignment: .leading) {
            Text("A code was sent to \(self.unformattedPhoneNumber).")
                .padding(.bottom, 40)
            TextField("Enter code received", text: $store.confirmationCode)
                .placeholder(when: self.store.confirmationCode.isEmpty) {
                    Text("Code received").opacity(0.6)
                }
                .keyboardType(.numberPad)
                .inputStyle()
                .padding(.bottom, 10)
            PhoneSignUpConfirmCodeResendView(phoneNumber: self.unformattedPhoneNumber, timeRemaining: self.timeRemaining) {
                self.store.resendCode()
            }
            Spacer()
            HStack {
                Spacer()
                Button {
                    self.store.verifyCode()
                } label: {
                    Label("Verify code entered", systemImage: "chevron.right")
                        .font(.system(size: 25))
                        .labelStyle(.iconOnly)
                        .padding(5)
                }.buttonStyle(.borderedProminent)
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
