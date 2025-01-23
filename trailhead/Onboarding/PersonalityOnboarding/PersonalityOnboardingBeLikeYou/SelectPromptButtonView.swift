//
//  SelectPromptView.swift
//  trailhead
//
//  Created by Robin Götz on 1/21/25.
//

import SwiftUI

struct SelectPromptButtonView: View {
    let onTab: () -> Void
    var body: some View {
        Button(action: {
            self.onTab()}) {
            VStack(alignment: .leading) {
                Text("Select a prompt")
                    .font(.subheadline)
                    .italic()
                    .bold()
                Text("And write your own answer")
                    .italic()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .inset(by: 3) // inset value should be same as lineWidth in .stroke
                    .stroke(.blue, lineWidth: 3)
            )
            .overlay(
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title)
                    .cornerRadius(100)
                    .padding(10)
                    .offset(x: 15, y: -15),
                alignment: .topTrailing
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SelectPromptButtonView{
        print("hello")
    }
}
