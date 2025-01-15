//
//  ContentView.swift
//  trailhead
//
//  Created by Robin Götz on 12/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var isAuthenticated = false

    var body: some View {
        OnboardingView()
    }
}

#Preview {
    ContentView()
}
