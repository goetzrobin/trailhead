//
//  InputViewModifier.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import SwiftUI

struct InputStyle: ViewModifier {
    let backgroundColor: Color
    let foregroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(minWidth: 80, minHeight: 47)
            .background(
                backgroundColor,
                in: RoundedRectangle(
                    cornerRadius: 18, style: .continuous)
            )
            .foregroundColor(foregroundColor)
    }
}

// Add a convenience extension to View
extension View {
    func inputStyle(
    ) -> some View {
        modifier(InputStyle(
            backgroundColor: .white,
            foregroundColor: .black
        ))
    }
}
