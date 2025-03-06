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
    @Environment(CidiAPIClient.self) var cidiAPIClient
    @Environment(ApplicationViewLayoutService.self) var layoutService: ApplicationViewLayoutService
    
    var journey: Journey {
        .init(id: UUID(), title: "Find Your Values", description: "An exploration of what is important to you and what you value in a career", backgroundColor: .jAccent, pattern: Pattern.dots, sessions: self.sessionAPIClient.fetchSessionsStatus.data ?? [])
    }

    let columns = [GridItem(.flexible(), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Button(action: {router.path.append(StudyPath.pre)}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.3))
                            .overlay(
                                PatternOverlay(pattern: Pattern.stripes)
                                    .opacity(0.1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            // Journey Title
                            Text("Join our study!")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            // Journey Description
                            Text("Fill out a quick survey to help us understand your career aspritations and values better.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(2)
                        }
                        .padding()

                    }
                }
                .buttonStyle(.plain)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    JourneyCard(journey: journey) {
                        router.path.append(journey)
                    }                .disabled(self.cidiAPIClient.fetchCombinedSurveyStatus.data?.pre == nil)

                }
                
                Button(action: {router.path.append(StudyPath.post)}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.3))
                            .overlay(
                                PatternOverlay(pattern: Pattern.stripes)
                                    .opacity(0.1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            // Journey Title
                            Text("Complete the study!")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            // Journey Description
                            Text("Fill out a final survey to see how effective Sam's mentorship was.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(2)
                        }
                        .padding()

                    }
                }
                .buttonStyle(.plain)
                .disabled(journey.sessions.count == 0 || !journey.sessions.allSatisfy {$0.isCompleted})

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
    @Previewable @State var auth =  AuthStore()
    NavigationStack(path: $router.path) {
        GrowthView()
            .environment(router)
            .environment(CidiAPIClient(authProvider: auth))
            .environment(SessionAPIClient(authProvider: auth))
            .environment(ApplicationViewLayoutService())
    }
}
