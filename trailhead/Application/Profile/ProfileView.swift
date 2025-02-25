import SwiftUI

struct ProfileView: View {
    @Environment(AuthStore.self) private var auth
    @Environment(AppRouter.self) private var router
    @Environment(UserAPIClient.self) private var userClient
    @State private var showingSignOutConfirmation = false

    var body: some View {
        Form {
            Section {
                NavigationLink(
                    destination: PersonalInfoView(
                        user: userClient.fetchUserStatus.data,
                        onSave: { data, showAlert in
                            Task {
                                await self.userClient.updateUser(
                                    with: data, onSuccess: showAlert)
                            }
                        })
                ) {
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text("Name & Pronouns")
                        } icon: {
                            Image(systemName: "person")
                                .accessibilityHidden(true)
                        }
                    }
                }

                NavigationLink(destination: BirthdayView()) {
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text("Birthday")
                        } icon: {
                            Image(systemName: "gift")
                                .accessibilityHidden(true)
                        }
                    }
                }
            } header: {
                Text("Personalization")
            } footer: {
                Text(
                    "This information helps Sam provide more personalized guidance and support during your conversations."
                )
            }

            Section {
                NavigationLink(destination: PasswordView()) {
                    Label {
                        Text("Change Password")
                    } icon: {
                        Image(systemName: "lock")
                            .accessibilityHidden(true)
                    }
                }
            } header: {
                Text("Privacy & Security")
            } footer: {
                Text(
                    "Your privacy matters. Your conversations with Sam are protected by industry-standard encryption."
                )
            }

            // Sign Out Section
            Section {
                Button(role: .destructive) {
                    showingSignOutConfirmation = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Sign Out")
                        Spacer()
                    }
                }
            }

            // App Information Footer
            Section {
            } footer: {
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Image(.logoLight)
                            .resizable()
                            .opacity(0.2)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                            .accessibilityHidden(true)

                        Text(
                            "Version \(Bundle.main.releaseVersionNumber ?? "0").\(Bundle.main.buildVersionNumber ?? "0")"
                        )
                        .font(.footnote)
                        .foregroundStyle(.tertiary)

                        Text("Made for athletes. By athletes.")
                            .foregroundStyle(.tertiary)
                            .padding(.top, 16)
                    }
                    Spacer()
                }
                .padding(.vertical)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Your Profile")
        .navigationBarTitleDisplayMode(.large)
        .alert("Sign Out", isPresented: $showingSignOutConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) {
                Task {
                    print("Signing out")
                    await auth.signOut()
                }
            }
        } message: {
            Text(
                "Are you sure you want to sign out?"
            )
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environment(AppRouter())
            .environment(UserAPIClient(authProvider: AuthStore()))
    }
}
