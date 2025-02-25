//
//  AuthSessionRefreshModifier.swift
//  trailhead
//
//  Created by Robin Götz on 2/18/25.
//
import SwiftUI
struct AuthSessionRefreshModifier: ViewModifier {
    let authStore: AuthStore
    @Environment(\.scenePhase) private var scenePhase

    func body(content: Content) -> some View {
        content
            .onAppear {
                Task {
                    await authStore.refreshSession()
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    Task {
                        await authStore.refreshSession()
                    }
                }
            }
    }
}

extension View {
    func refreshSessionOnAppear(_ authStore: AuthStore) -> some View {
        self.modifier(AuthSessionRefreshModifier(authStore: authStore))
    }
}
