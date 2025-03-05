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
    @State private var onboardingLetterAPIClient: OnboardingLetterAPIClient
    @State private var onboardingCompleteApiClient: CompleteOnboardingAPIClient
    @State private var onboardingStore: OnboardingStore
    
    
    @State private var showingAuth: Bool
    @State private var inInitialConversation: Bool = false
    @State private var initialConversationSessionLogId: UUID?
    
    init() {
        let authStore = AuthStore()
        self.authStore = authStore
        
        self.userAPIClient = UserAPIClient(authProvider: authStore)
        self.sessionAPIClient = SessionAPIClient(authProvider: authStore)
        self.checkInAPIClient = CheckInAPIClient(authProvider: authStore)
        self.onboardingLetterAPIClient = OnboardingLetterAPIClient(
            authProvider: authStore
        )
        self.onboardingCompleteApiClient = CompleteOnboardingAPIClient(
            authProvider: authStore
        )

        self.onboardingStore = OnboardingStore()
        self.showingAuth = false
    }
    

    var debug = true
    var body: some View {
        VStack {
            Text("\(authStore.isOnboardingCompleted) \(authStore.isAuthenticated)" )
            if authStore.isAuthenticated && authStore.isOnboardingCompleted {
                VStack {
                    ApplicationView()
                        .navigationBarBackButtonHidden()
                        .environment(self.authStore)
                        .environment(self.userAPIClient)
                        .environment(self.sessionAPIClient)
                        .environment(self.checkInAPIClient)
                        .refreshSessionOnAppear(self.authStore)
                        .onAppear {
                            if let userId = authStore.userId {
                                self.userAPIClient.fetchUser(by: userId)
                                self.sessionAPIClient
                                    .fetchSessionsWithLogs(for: userId)
                                self.checkInAPIClient.fetchCheckInLogs(for: userId)
                            }
                        }
                        .onChange(of: authStore.userId) { _, userId in
                            if let userId = userId {
                                self.userAPIClient.fetchUser(by: userId)
                                self.sessionAPIClient
                                    .fetchSessionsWithLogs(for: userId)
                            }
                        }
                }
            } else if inInitialConversation, let userId = authStore.userId, let initialConversationSessionLogId = initialConversationSessionLogId {
                ConversationView(sessionApiClient: sessionAPIClient, authProvider: authStore, slug: "onboarding-v0", userId: userId, sessionLogId: initialConversationSessionLogId, maxSteps: 5, customEndConversationLabel: "Complete onboarding!", onSessionEnded: {
                    Task {
                        await self.authStore.fetchUser() {
                            inInitialConversation = false
                        }
                    }
                } ).tint(.jAccent)
            } else {
                OnboardingView(
                    showingAuth: $showingAuth,
                    auth: authStore,
                    userApiClient: userAPIClient,
                    onboardingLetterApiClient: onboardingLetterAPIClient,
                    onboardingCompleteApiClient: onboardingCompleteApiClient
                ) { sessionLogId in
                    initialConversationSessionLogId = sessionLogId
                    inInitialConversation = true
                    onboardingStore.completeOnboarding()
                }
                .tint(.jAccent)
                .sheet(isPresented: $showingAuth) {
                    AuthContainerView(authStore: authStore)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
