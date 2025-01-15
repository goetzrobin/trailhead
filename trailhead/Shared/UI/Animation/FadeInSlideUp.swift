//
//  FadeInSlideUp.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//

import SwiftUI

// First, let's create our custom ViewModifier
struct FadeInSlideUp: ViewModifier {
    // The single boolean input that controls the animation state
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            .blur(radius: isVisible ? 0 : 2)
            .animation(
                .spring(Spring(duration: 1.5, bounce: 0.25)),
                value: isVisible
            )
    }
}

// Now let's create a View extension to make it even easier to use
extension View {
    // This function provides a more natural SwiftUI-style modifier syntax
    func fadeInSlideUp(isVisible: Bool) -> some View {
        modifier(FadeInSlideUp(isVisible: isVisible))
    }
}
