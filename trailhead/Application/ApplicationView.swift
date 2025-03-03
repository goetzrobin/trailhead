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

@Observable final class ApplicationViewLayoutService {
    private(set) var isShowingTabBar: Bool = true
    
    func showTabBar(animate: Bool) {
        if animate {
            withAnimation {
                self.isShowingTabBar = true
            }
        } else {
            self.isShowingTabBar = true
        }
    }
    
    func hideTabBar(animate: Bool) {
        if animate {
            withAnimation {
                self.isShowingTabBar = false
            }
        } else {
            self.isShowingTabBar = false
        }
    }
}

struct ApplicationView: View {
    @State private var selectedTab: ApplicationTab = .checkIn
    @Environment(\.colorScheme) private var colorScheme
    @Environment(AuthStore.self) private var authStore
    @State private var checkInRouter = AppRouter()
    @State private var growthRouter = AppRouter()
    @State private var profileRouter = AppRouter()
    @State private var layoutService = ApplicationViewLayoutService()

    var body: some View {
        @Bindable var checkInRouter = checkInRouter
        @Bindable var growthRouter = growthRouter
        @Bindable var profileRouter = profileRouter

        TabView(selection: $selectedTab) {
            Group {
                NavigationStack(path: self.$checkInRouter.path) {
                    CheckInView()
                }
                .tabItem {
                    Image(systemName: "plus.bubble.fill")
                    Text("Check In")
                }
                .tag(ApplicationTab.checkIn)
                .environment(checkInRouter)

                NavigationStack(path: self.$growthRouter.path) {
                    GrowthView()
                }
                .tabItem {
                    Image(
                        systemName:
                            "point.bottomleft.forward.to.arrow.triangle.uturn.scurvepath.fill"
                    )
                    Text("Growth")
                }
                .tag(ApplicationTab.growth)
                .environment(growthRouter)
                .environment(layoutService)

                NavigationStack(path: self.$profileRouter.path) {
                    ProfileView()
                }
                .tabItem {
                    Image(systemName: "circle.fill")
                    Text("Robin")
                }
                .tag(ApplicationTab.profile)
                .environment(profileRouter)
            }
            .modifier(GradientOverlayModifier(active: self.layoutService.isShowingTabBar))
            .toolbar(self.layoutService.isShowingTabBar ? .visible : .hidden, for: .tabBar)
            .toolbarBackground(.hidden, for: .tabBar)
        }
        .tint(Color.jAccent)
    }
}

struct GradientOverlayModifier: ViewModifier {
    let active: Bool
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
                            .init(
                                color: Color(.systemBackground).opacity(1),
                                location: 1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 120)
                }
                .allowsHitTesting(false)
                .ignoresSafeArea()
                .opacity(active ? 1 : 0)
            }
    }
}

#Preview {
    ApplicationView()
        .environment(AuthStore())
}
