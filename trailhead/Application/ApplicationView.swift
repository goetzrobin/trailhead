//
//  SwiftUIView.swift
//  trailhead
//
//  Created by Robin Götz on 1/31/25.
//

import SwiftUI

enum ApplicationTab {
    case checkIn
    case growth
    case profile
}

struct GradientOverlayModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                VStack {
                    Spacer()
                    LinearGradient(
                        stops: [
                            .init(
                                color: Color(.systemBackground).opacity(0),
                                location: 0),
                            .init(
                                color: Color(.systemBackground).opacity(0.9),
                                location: 0.9),
                            .init(color: Color(.systemBackground).opacity(1),
                            location: 1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 120)
                }
                .allowsHitTesting(false)
                .ignoresSafeArea()
            }
    }
}

struct ApplicationView: View {
    @Environment(AppRouter.self) private var router
    @State private var selectedTab: ApplicationTab = .checkIn
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        @Bindable var router = self.router
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                Group {
                    NavigationStack(path: $router.path) {
                        CheckInView()
                    }
                    .modifier(GradientOverlayModifier())
                    .tabItem {
                        Image(systemName: "plus.bubble.fill")
                        Text("Check In")
                    }
                    .tag(ApplicationTab.checkIn)

                    NavigationStack(path: $router.path) {
                        Text("Growth")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background((Color(.white)))
                    }
                    .modifier(GradientOverlayModifier())
                    .tabItem {
                        Image(
                            systemName:
                                "point.bottomleft.forward.to.arrow.triangle.uturn.scurvepath.fill"
                        )
                        Text("Growth")
                    }
                    .tag(ApplicationTab.growth)

                    NavigationStack(path: $router.path) {
                        Text("Profile")
                    }
                    .modifier(GradientOverlayModifier())
                    .tabItem {
                        Image(systemName: "circle.fill")
                        Text("Robin")
                    }
                    .tag(ApplicationTab.profile)
                }
                .toolbarBackground(.hidden, for: .tabBar)
            }
        }
    }
}

#Preview {
    ApplicationView()
        .environment(AppRouter())
}
