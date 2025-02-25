//
//  PersonalInfoView.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//

import SwiftUI

struct PersonalInfoView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var showingConfirmation = false
    @State private var hasChanges = false
    @State private var name: String
    @State private var pronouns: String

    let user: User?
    let onSave: ((_ data: UserUpdateData, _ showAlert: (() -> Void)?) -> Void)?

    init(user: User?, onSave: ((_ data: UserUpdateData, _ showAlert: (() -> Void)?) -> Void)? = nil) {
        self.name = user?.name ?? ""
        self.pronouns = user?.pronouns ?? ""
        self.user = user
        self.onSave = onSave
    }

    var body: some View {
        Form {
            Section {
                TextField("Enter your name", text: $name)
                    .textContentType(.name)
                    .onChange(of: name) { hasChanges = true }

                TextField("Add your pronouns (optional)", text: $pronouns)
                    .onChange(of: pronouns) { hasChanges = true }
            } footer: {
                Text(
                    "Sam will use this information to provide more personalized guidance. This helps create a more meaningful mentorship experience."
                )
            }
        }
        .navigationTitle("Name & Pronouns")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    if let onSave = onSave {
                        onSave(UserUpdateData(name: name, pronouns: pronouns)) {
                            showingConfirmation = true
                        }
                    }
                }
                .disabled(!hasChanges)
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(.secondary)
            }
        }
        .alert("Profile Updated", isPresented: $showingConfirmation) {
            Button("Continue", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(
                "Sam will use your updated information in future conversations."
            )
        }
    }
}

#Preview {
    PersonalInfoView(user: nil)
}
