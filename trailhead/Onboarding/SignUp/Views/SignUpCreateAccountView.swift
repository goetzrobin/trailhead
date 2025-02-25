//
//  SignUpEnterNumberView.swift
//  trailhead
//
//  Created by Robin Götz on 2/13/25.
//

import Observation
import SwiftUI

struct SignUpCreateAccountView: View {
    @Environment(SignUpStore.self) private var store

    // State for field validation and accessibility
    @State private var isPasswordValid = false
    @State private var showPassword = false

    var body: some View {
        @Bindable var store = self.store
        VStack(alignment: .leading) {
            Text(
                "First up: create your account with email. Then we'll help you set up your profile."
            )
            .foregroundStyle(.secondary)
            .padding(.bottom, 40)

            // Email input with validation
            VStack(alignment: .leading, spacing: 8) {
                Text("Email address")
                    .fontWeight(.medium)
                TextField("", text: $store.email)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .accessibilityLabel("Enter your email address")
            }

            // Password input with requirements
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .fontWeight(.medium)
                HStack {
                    if showPassword {
                        TextField("", text: $store.password)
                    } else {
                        SecureField("", text: $store.password)
                    }
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                    .accessibilityLabel(
                        showPassword ? "Hide password" : "Show password")
                }
                .textFieldStyle(.roundedBorder)
                .textContentType(.newPassword)

                // Anticipation: Guide users with password requirements
                Text(
                    "Password must be at least 8 characters and include a number"
                )
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            Spacer()
            HStack {
                Spacer()
                ContinueButton(
                    label: "Send code to my phone number",
                    isLoading: store.signUpStatus == .loading
                ) {
                    Task {
                        await self.store.triggerSignUp()
                    }
                }
                .disabled(!self.store.isEmailSignUpValid)
            }

        }
        .frame(minHeight: 0, maxHeight: .infinity)
    }
}

#Preview {
    SignUpCreateAccountView().environment(SignUpStore(auth: AuthStore()))
}
