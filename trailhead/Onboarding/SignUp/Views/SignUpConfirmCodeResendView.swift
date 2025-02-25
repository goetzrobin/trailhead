//
//  PhoneSignUpConfirmCodeResendView.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import SwiftUI

struct SignUpConfirmCodeResendView: View {
    var phoneNumber: String = ""
    var timeRemaining: Int = 0
    let onResendTap: () -> Void
    
    init(phoneNumber: String, timeRemaining: Int, onResendTap: @escaping () -> Void) {
        self.phoneNumber = phoneNumber
        self.timeRemaining = timeRemaining
        self.onResendTap = onResendTap
    }
    
    var body: some View {
            Text(try!
                 AttributedString(markdown: "Have you still not received a code at  \(self.phoneNumber)? \(self.timeRemaining > 0 ? String(format: "Resend in 00:%02d", self.timeRemaining) : "[Resend in 00:00](resend_code_tapped)")"
            ))
            .font(.footnote)
            .bold()
        .environment(\.openURL, OpenURLAction { url in
            if url == URL(string: "resend_code_tapped") { // <<
                self.onResendTap()
                return .handled
            }
            return .systemAction
        })
    }

}

#Preview {
    SignUpConfirmCodeResendView(phoneNumber: "123", timeRemaining: 0) {
        print("yo")
    }
}
