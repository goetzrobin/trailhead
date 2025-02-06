//
//  SelectPromptView.swift
//  trailhead
//
//  Created by Robin Götz on 1/21/25.
//

import SwiftUI

struct EmptyPromptItemView: View {
    let onTab: () -> Void
    var body: some View {
        Button(action: {
            self.onTab()
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Select a prompt")
                        .font(.subheadline)
                        .italic()
                        .bold()
                        .padding(.bottom, 2)
                    Text("And write your own answer")
                        .italic()
                        .padding(.bottom, 12)
                }
                Spacer()
                Text("Add")
                    .font(.system(size: 12))
                    .bold()
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.jAccent)
                    )

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .inset(by: 3)  // inset value should be same as lineWidth in .stroke
                    .stroke(Color.jAccent, lineWidth: 3)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    EmptyPromptItemView {
        print("hello")
    }
}
