//
//  ContinueButton.swift
//  trailhead
//
//  Created by Robin Götz on 1/25/25.
//

import SwiftUI

struct ContinueButton: View {
    let label: String
    var isLoading = false
    let onTab: () -> Void
    
    var body: some View {
        Button {
            self.onTab()
        } label: {
            if self.isLoading {
                ProgressView()
                    .frame(width: 24, height: 24)
                    .tint(.black)
            } else {
                Label(self.label, systemImage: "chevron.right")
                    .buttonIconLabelStyle()
                    .padding(.horizontal, 4)
            }
        }
        .buttonStyle(.jPrimary)
    }
}

#Preview {
    ContinueButton(label: "Do something") {
        print("Do something cool")
    }
}
