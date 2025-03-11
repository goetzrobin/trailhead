//
//  InvertedModifier.swift
//  trailhead
//
//  Created by Robin Götz on 3/9/25.
//
import SwiftUI

struct Inverted: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.radians(Double.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

extension View {
    func inverted() -> some View {
        modifier(Inverted())
    }
}
