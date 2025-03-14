//
//  DelayedAppreanceModifier.swift
//  trailhead
//
//  Created by Robin Götz on 1/16/25.
//
import SwiftUI

extension View {
    func signUpSuccessDelayedAppearance(delay: Double) -> some View {
        self.modifier(SignUpSuccessDelayedAppearanceModifier(delay: delay))
    }
}

struct SignUpSuccessDelayedAppearanceModifier: ViewModifier {
    let delay: Double
    @State private var isShowing = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isShowing ? 1 : 0)
            .scaleEffect(isShowing ? 1 : 0.5)
            .animation(.spring(duration: 0.5, bounce: 0.3), value: isShowing)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation {
                        isShowing = true
                    }
                }
            }
    }
}
