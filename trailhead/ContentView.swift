//
//  ContentView.swift
//  trailhead
//
//  Created by Robin Götz on 12/11/24.
//

import Observation
import SwiftUI

struct ContentView: View {
    @State private var authStore: AuthStore
    @State private var userAPIClient: UserAPIClient
    @State private var sessionAPIClient: SessionAPIClient
    @State private var checkInAPIClient: CheckInAPIClient
    @State private var onboardingStore: OnboardingStore
    @State private var showingAuth: Bool
    
    init() {
        let authStore = AuthStore()
        self.authStore = authStore
        
        self.userAPIClient = UserAPIClient(authProvider: authStore)
        self.sessionAPIClient = SessionAPIClient(authProvider: authStore)
        self.checkInAPIClient = CheckInAPIClient(authProvider: authStore)

        self.onboardingStore = OnboardingStore()
        self.showingAuth = false
    }

    var body: some View {
        if authStore.isAuthenticated && authStore.isOnboardingCompleted {
            VStack {
                ApplicationView()
                    .navigationBarBackButtonHidden()
                    .environment(self.authStore)
                    .environment(self.userAPIClient)
                    .environment(self.sessionAPIClient)
                    .refreshSessionOnAppear(self.authStore)
                    .onAppear {
                        if let userId = authStore.userId {
                            self.userAPIClient.fetchUser(by: userId)
                            self.sessionAPIClient.fetchSessionsWithLogs(for: userId)
                            self.checkInAPIClient.fetchCheckInSessions(for: userId)
                        }
                    }
                    .onChange(of: authStore.userId) { _, userId in
                        if let userId = userId {
                            self.userAPIClient.fetchUser(by: userId)
                            self.sessionAPIClient.fetchSessionsWithLogs(for: userId)
                        }
                    }
            }
        } else {
            OnboardingView(showingAuth: $showingAuth, auth: authStore) {
                onboardingStore.completeOnboarding()
            } .sheet(isPresented: $showingAuth) {
                AuthContainerView(authStore: authStore)
            }
        }
    }
}

#Preview {
    ContentView()
}
