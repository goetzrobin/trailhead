//
//  InputViewModifier.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import SwiftUI

struct ButtonIconLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .labelStyle(.iconOnly)
            .font(.system(size: 14))
            .bold()
    }
}

// Add a convenience extension to View
extension View {
    func buttonIconLabelStyle(
    ) -> some View {
        modifier(ButtonIconLabelModifier())
    }
}
