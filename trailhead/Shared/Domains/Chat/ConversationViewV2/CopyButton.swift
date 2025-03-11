//
//  CopyButton.swift
//  trailhead
//
//  Created by Robin Götz on 3/10/25.
//
import SwiftUI

struct CopyButton: View {
    let textToCopy: String
    @State private var isCopied = false
    
    var body: some View {
        Button(action: {
            UIPasteboard.general.string = textToCopy
            withAnimation(.spring(duration: 0.25)) {
                isCopied = true
            }
            
            // Reset back to original icon after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.spring(duration: 0.25)) {
                    isCopied = false
                }
            }
        }, label: {
            Label(
                isCopied ? "Copied" : "Copy message",
                systemImage: isCopied ? "checkmark" : "square.on.square"
            )
            .font(.system(size: 15))
            .foregroundStyle(.secondary)
            .labelStyle(.iconOnly)
        })
        .frame(width: 18, height: 18)
        .buttonStyle(.plain)
    }
}
