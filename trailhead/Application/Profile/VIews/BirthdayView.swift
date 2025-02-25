//
//  BirthdayView.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//

import SwiftUI

struct BirthdayView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var birthDate =
        UserDefaults.standard.object(forKey: "userBirthday") as? Date ?? Date()
    @State private var showingConfirmation = false
    @State private var hasChanges = false

    var body: some View {
        Form {
            Section {
                DatePicker(
                    "Select your birthday",
                    selection: $birthDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .onChange(of: birthDate) { hasChanges = true }
            } footer: {
                Text(
                    "Your birthday helps Sam provide better guidance and celebrate your milestones with you."
                )
            }
        }
        .navigationTitle("Your Birthday")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveChanges()
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
        .alert("Birthday Updated", isPresented: $showingConfirmation) {
            Button("Continue", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Sam will keep this in mind during your conversations.")
        }
    }

    private func saveChanges() {
        UserDefaults.standard.set(birthDate, forKey: "userBirthday")
        showingConfirmation = true
    }
}

#Preview {
    BirthdayView()
}
