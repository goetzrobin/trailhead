//
//  PhoneSignUpStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import Foundation

@Observable class PhoneSignUpStore {
    var phoneNumber = ""
    var currentCountryCode: PhoneCountryCode = PhoneCountryCode.US

    var unformattedPhoneNumber: String {
        return
            "\(self.currentCountryCode.dial_code)\(self.phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression))"
    }

    var confirmationCode = ""

    var onCodeSent: (() -> Void)?
    var onCodeVerified: (() -> Void)?

    private(set) var codeVerified = false

    func setupCallbacks(
        onCodeSent: (() -> Void)?, onCodeVerified: (() -> Void)?
    ) {
        self.onCodeSent = onCodeSent
        self.onCodeVerified = onCodeVerified
    }

    func sendCode() {
        print("Send code to phone number: \(phoneNumber)")
        self.onCodeSent?()
    }

    func resendCode() {
        print("Resend code to phone number: \(phoneNumber)")
    }

    func verifyCode() {
        print("Verify code: \(confirmationCode) for number \(phoneNumber)")
        self.codeVerified = true
        self.onCodeVerified?()
    }
}
