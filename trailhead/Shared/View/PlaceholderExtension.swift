//
//  PlaceholderExtension.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//
import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        allowHitTesting: Bool = false,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder()
                    .opacity(shouldShow ? 1 : 0)
                    .allowsHitTesting(allowHitTesting)
                self
            }
        }
}
