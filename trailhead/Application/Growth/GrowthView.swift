//
//  GrowthView.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//

import SwiftUI

struct GrowthView: View {
    var body: some View {
        GrowthGridView()
    }
}

enum StudyPath {
    case pre
    case post
}

struct GrowthGridView: View {
    @Environment(AppRouter.self) var router
    @Environment(SessionAPIClient.self) var sessionAPIClient
    @Environment(ApplicationViewLayoutService.self) var layoutService: ApplicationViewLayoutService
    
    var journey: Journey {
        .init(id: UUID(), title: "Find Your Values", description: "An exploration of what is important to you and what you value in a career", backgroundColor: .jAccent, pattern: Pattern.dots, sessions: self.sessionAPIClient.fetchSessionsStatus.data ?? [])
    }

    let columns = [GridItem(.flexible(), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Button("Start Initial Survey") {
                    router.path.append(StudyPath.pre)
                }
                LazyVGrid(columns: columns, spacing: 16) {
                    JourneyCard(journey: journey) {
                        router.path.append(journey)
                    }
                }
                Button("Start Final Survey") {
                    router.path.append(StudyPath.post)
                }
            }
            .padding()
        }
        .navigationTitle("Growth")
        .navigationDestination(for: Journey.self) { journey in
            JourneyDetailView(journey: journey)
        }
        .navigationDestination(for: StudyPath.self) {
            path in
            CidiNavigationContainer(timing: path == .pre ? CidiTiming.pre : CidiTiming.post)
        }
        .onAppear {
            layoutService.showTabBar(animate: true)
        }
    }
}

#Preview {
    @Previewable @State var router = AppRouter()
    NavigationStack(path: $router.path) {
        GrowthView()
            .environment(AppRouter())
    }
}
