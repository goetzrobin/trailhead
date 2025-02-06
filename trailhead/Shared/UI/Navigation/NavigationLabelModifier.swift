//
//  InputViewModifier.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import SwiftUI

struct NavigationLabelStyle<S: LabelStyle>: ViewModifier {
    var labelStyle: S

    init(labelStyle: S = .iconOnly) {
        self.labelStyle = labelStyle
    }

    func body(content: Content) -> some View {
        content
            .frame(width: labelStyle is IconOnlyLabelStyle ? 18 : nil)
            .font(.system(size: labelStyle is IconOnlyLabelStyle ? 12 : 14))
            .labelStyle(labelStyle)
            .padding(8)
            .background(labelStyle is IconOnlyLabelStyle ?  Material.ultraThinMaterial.opacity(1) : Material.regular.opacity(0))
            .cornerRadius(8)
    }
}

// Add a convenience extension to View
extension View {
    func navigationLabelStyle<S: LabelStyle>(
         _ labelStyle: S = .iconOnly
     ) -> some View {
         modifier(NavigationLabelStyle(labelStyle: labelStyle))
     }
}
