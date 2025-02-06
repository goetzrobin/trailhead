//
//  ContinueButton.swift
//  trailhead
//
//  Created by Robin Götz on 1/25/25.
//

import SwiftUI

struct ContinueButton: View {
    let label: String
    let onTab: () -> Void
    
    var body: some View {
        Button {
            self.onTab()
        } label: {
            Label(self.label, systemImage: "chevron.right")
                .buttonIconLabelStyle()
                .padding(.horizontal, 4)
        }
        .buttonStyle(.jPrimary)
    }
}

#Preview {
    ContinueButton(label: "Do something") {
        print("Do something cool")
    }
}
