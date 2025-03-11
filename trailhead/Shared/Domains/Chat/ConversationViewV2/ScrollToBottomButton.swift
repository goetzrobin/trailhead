//
//  ScrollToBottomButton.swift
//  trailhead
//
//  Created by Robin Götz on 3/10/25.
//
import SwiftUI

struct ScrollToBottomButton: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap,
               label: {
            Label(
                "Scroll to newest message",
                systemImage: "arrow.down"
            )
            .frame(width: 8, height: 18)
            .labelStyle(.iconOnly)
        })
        .cornerRadius(50)
        .buttonStyle(.bordered)
    }
}
