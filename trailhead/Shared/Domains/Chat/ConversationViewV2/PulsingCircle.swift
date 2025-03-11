//
//  PulsingCircle.swift
//  trailhead
//
//  Created by Robin Götz on 3/10/25.
//
import SwiftUI

struct PulsingCircle: View {
    // Animation state
    @State private var isAnimating = false
    
    // Customizable properties
    var minScale: CGFloat = 0.7
    var maxScale: CGFloat = 1.0
    var minOpacity: CGFloat = 0.85
    var maxOpacity: CGFloat = 1.0
    var duration: Double = 0.85
    var baseSize: CGFloat = 17
    
    
    var body: some View {
        Circle()
            .fill(.foreground)
            .frame(width: baseSize, height: baseSize)
            .scaleEffect(isAnimating ? maxScale : minScale)
            .opacity(isAnimating ? maxOpacity : minOpacity)
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}
