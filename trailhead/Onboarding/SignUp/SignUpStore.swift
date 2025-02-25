//
//  PhoneSignUpStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import Foundation

@Observable final class SignUpStore: Sendable {
    let auth: AuthStore

    var email = ""
    var password = ""

    init(auth: AuthStore) {
        self.auth = auth
    }

    var isPasswordValid: Bool {
        self.password.count > 8 && self.password.contains { $0.isNumber }
    }

    var isEmailSignUpValid: Bool {
        !self.email.isEmpty && self.email.contains("@") && self.isPasswordValid
    }

    var phoneNumber = ""
    var currentCountryCode: PhoneCountryCode = PhoneCountryCode.US

    var unformattedPhoneNumber: String {
        return
            "\(self.currentCountryCode.dial_code)\(self.phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression))"
    }

    var confirmationCode = ""

    var onSignUpSuccess: (() -> Void)?

    private(set) var codeVerified = false

    func setupCallbacks(
        onSignUpSuccess: (() -> Void)?
    ) {
        self.onSignUpSuccess = onSignUpSuccess
    }

    func sendCode() {
        print("Send code to phone number: \(phoneNumber)")
    }

    func resendCode() {
        print("Resend code to phone number: \(phoneNumber)")
    }

    func verifyCode() {
        print("Verify code: \(confirmationCode) for number \(phoneNumber)")
        self.codeVerified = true
    }

    var signUpStatus: ResponseStatus<Void> {
        self.auth.signUpStatus
    }

    func triggerSignUp() async {
        print("Sign up")
        if !self.isEmailSignUpValid { return }
        await self.auth.signUp(email: self.email, password: self.password) {
            DispatchQueue.main.async {
                self.onSignUpSuccess?()
            }
        }
    }
}
