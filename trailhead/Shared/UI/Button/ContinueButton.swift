//
//  ContinueButton.swift
//  trailhead
//
//  Created by Robin Götz on 1/25/25.
//

import SwiftUI

struct ContinueButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
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
                    .tint(self.colorScheme == .light ? .white : .black)
            } else {
                Label(self.label, systemImage: "chevron.right")
                    .buttonIconLabelStyle()
                    .frame(width: 24, height: 24)
            }
        }
        .buttonStyle(.jPrimary)
    }
}

#Preview {
    @Previewable @State var isLoading: Bool = false
    ContinueButton(label: "Do something") {
        print("Do something cool")
    }
    ContinueButton(label: "Do something", isLoading: isLoading) {
        isLoading.toggle()
    }
}
