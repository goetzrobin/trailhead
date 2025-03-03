//
//  CloseHeader.swift
//  trailhead
//
//  Created by Robin Götz on 2/26/25.
//
import SwiftUI

struct CloseHeader: View {
    let onClose: () -> Void
    var body: some View {
        HStack {
            Spacer()
            Button {
                self.onClose()
            } label: {
                Label("Close", systemImage: "xmark")
                    .labelStyle(.iconOnly)
                    .padding()
            }
        }
    }
}
