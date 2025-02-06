//
//  ContentView.swift
//  trailhead
//
//  Created by Robin Götz on 12/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var appRouter = AppRouter()
    @State var isAuthenticated = true

    var body: some View {
        if isAuthenticated {
            NavigationStack(path: $appRouter.path) {
                ApplicationView()
                    .navigationBarBackButtonHidden()
                    .environment(appRouter)
            }
        } else {
            NavigationStack(path: $appRouter.path) {
                OnboardingView()
                    .environment(appRouter)
            }
        }
    }
}

#Preview {
    ContentView()
}
