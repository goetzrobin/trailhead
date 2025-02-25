//
//  PasswordView.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//

import SwiftUI

struct PasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showingError = false
    @State private var showingConfirmation = false
    @State private var errorMessage = ""

    var canSave: Bool {
        !newPassword.isEmpty && newPassword == confirmPassword
            && newPassword.count >= 8
    }

    var body: some View {
        Form {
            Section {
                SecureField("New password", text: $newPassword)
                    .textContentType(.newPassword)
                SecureField("Confirm new password", text: $confirmPassword)
                    .textContentType(.newPassword)
            } footer: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your new password must be at least 8 characters long")
                    if !newPassword.isEmpty && newPassword != confirmPassword {
                        Text("Passwords don't match")
                            .foregroundStyle(.red)
                    }
                }
            }

            Section {
            } footer: {
                Text(
                    "A strong password helps keep your conversations with Sam private and secure."
                )
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    updatePassword()
                }
                .disabled(!canSave)
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(.secondary)
            }
        }
        .alert("Unable to Change Password", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .alert("Password Updated", isPresented: $showingConfirmation) {
            Button("Continue", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(
                "Your password has been changed successfully. Your conversations with Sam remain secure."
            )
        }
    }

    private func updatePassword() {
        // TODO: Implement actual password update
        showingConfirmation = true
    }
}

#Preview {
    PasswordView()
}
