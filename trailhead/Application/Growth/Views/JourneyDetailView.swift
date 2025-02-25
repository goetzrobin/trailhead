//
//  JourneyDetailView.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//
import SwiftUI

struct JourneyDetailView: View {
    @Environment(SessionAPIClient.self) var sessionApiClient: SessionAPIClient
    @Environment(AuthStore.self) var auth: AuthStore
    let journey: Journey
    
    var sessions: [Session] {
        self.sessionApiClient.fetchSessionsStatus.data ?? []
    }

    var body: some View {

        VStack {
            Text(journey.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
            
            List {
                // Sessions
                Section(header: Text("Sessions")) {
                    ForEach(sessions.indices, id: \.self) { index in
                        let session = sessions[index]
                        let isEnabled = index == 0 || sessions[index - 1].isCompleted
                        
                        NavigationLink(destination: SessionDetailView(session: session)) {
                            SessionRow(session: session)
                        }
                        .disabled(!isEnabled)
                    }
                }
            }
            .navigationTitle(journey.title)
            .onAppear {
                print("refetching those messages")
                guard let userId = auth.userId else { return }
                self.sessionApiClient.fetchSessionsWithLogs(for: userId)
            }
        }
    }
}
#Preview {
    let authStore = AuthStore()
    NavigationStack {
        JourneyDetailView(journey: .preview)
            .environment(authStore)
            .environment(SessionAPIClient(authProvider: authStore))
    }
}
