//
//  UserOnboardingSubmittingInfoView.swift
//  trailhead
//
//  Created by Robin Götz on 2/28/25.
//

import SwiftUI

struct UserOnboardingSubmittingInfoView: View {
    @State private var isLoading = true

    let userApiClient: UserAPIClient
    let userId: UUID?
    let data: UserUpdateData
    let onComplete: () -> Void

    var body: some View {
        ZStack {

            VStack(spacing: 20) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(2.0)

                    Text("Saving your information...")
                        .font(.headline)
                        .padding(.top, 20)
                }
            }
        }
        .onAppear {
            if let userId = userId {
                userApiClient.updateUser(for: userId, with: data) { _ in
                    isLoading = false
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    UserOnboardingSubmittingInfoView(
        userApiClient: UserAPIClient(authProvider: AuthStore()),
        userId: UUID(),
        data: UserUpdateData(
            name: "Jane Doe",
            pronouns: "she/her",
            birthday: Date(),
            graduationYear: 2025,
            cohort: "current-athlete",
            genderIdentity: "woman",
            ethnicity: "prefer-not-to-say",
            competitionLevel: "college",
            ncaaDivision: "D1"
        ),
        onComplete: {}
    )
}
