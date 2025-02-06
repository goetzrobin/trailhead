//
//  EnterPromptResponseView.swift
//  trailhead
//
//  Created by Robin Götz on 1/22/25.
//

import SwiftUI

struct EnterPromptResponseView: View {

    let prompt: String
    let response: Binding<String>
    let maxCharsAllowed: Int
    let onCancel: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(prompt)
                    .font(.headline)
                    .padding(.bottom)
                ZStack(alignment: .topLeading) {
                    TextEditor(
                        text: response
                    )
                    .frame(minHeight: 100)
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                    Text("Let Sam know...")
                        .foregroundStyle(.primary)
                        .font(.title)
                        .bold()
                        .opacity(response.wrappedValue.isEmpty ? 0.8 : 0)
                        .padding(.top, 8)
                        .padding(.leading, 6)
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(30)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .inset(by: 3)  // inset value should be same as lineWidth in .stroke
                    .stroke(.thinMaterial, lineWidth: 3)
            )
            .padding(.bottom, 20)
            .padding(.horizontal, 10)
            Spacer()
            HStack {
                Button("Cancel") {
                    self.onCancel()
                }
                .buttonStyle(.plain)
                Spacer()
                Text(
                    "\(response.wrappedValue.count)/\(maxCharsAllowed)"
                )
                .padding(.trailing, 5)
                Button("Done") {
                    self.onDone()
                }
                .buttonStyle(.jAccent(horizontalPadding: 14, verticalPadding: 10))
                .disabled(response.wrappedValue.count == 0)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: onCancel) {
                    Label("Back", systemImage: "chevron.left")
                        .navigationLabelStyle()
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    EnterPromptResponseView(
        prompt: "I was today years old when I learned",
        response: $text, maxCharsAllowed: 160, onCancel: { print("Cancel") },
        onDone: { print("Done") })
}
