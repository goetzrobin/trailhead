//
//  ContentView.swift
//  trailhead
//
//  Created by Robin Götz on 12/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var navigationService = NavigationService()
    @State var isAuthenticated = false

    var body: some View {
        OnboardingView()
            .environment(navigationService)
    }
}

#Preview {
    ContentView()
}
