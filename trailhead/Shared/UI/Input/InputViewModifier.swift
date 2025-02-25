//
//  InputViewModifier.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import SwiftUI

struct InputStyle: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .padding(18)
            .frame(minWidth: 80, minHeight: 48)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(
                    cornerRadius: 18, style: .continuous)
            )
            .foregroundStyle(.foreground)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(colorScheme == .light ? .black : .white.opacity(0.4), lineWidth: 2)  // Add dark border
            )
    }
}

// Add a convenience extension to View
extension View {
    func inputStyle() -> some View {
        modifier(InputStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
                Text("Styled Text")
                    .inputStyle()
                
        TextField("Enter code", text: .constant(""), prompt: Text("Redeem Code"))
                    .textFieldStyle(PlainTextFieldStyle())
                    .inputStyle()

                Button(action: {}) {
                    Text("Styled Button")
                }
                .inputStyle()
            }
            .padding()
}
