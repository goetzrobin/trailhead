//
//  PromptListView.swift
//  trailhead
//
//  Created by Robin Götz on 1/29/25.
//

import SwiftUI

struct PromptListView: View {
    let promptAndResponses: [PromptOptionAndResponse?]
    let onChooseNewPrompt: (_ index: Int) -> Void
    let onUpdatePrompt: (_ index: Int) -> Void

    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<3, id: \.self) { index in
                ZStack {
                    EmptyPromptItemView {
                        self.onChooseNewPrompt(index)
                    }
                    .opacity(
                        self.promptAndResponses[index]?.response
                            == nil ? 1 : 0)
                    Button(
                        action: {
                            self.onUpdatePrompt(index)
                        },
                        label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(
                                        self.promptAndResponses[index]?.option
                                            .prompt
                                            ?? "No prompt"
                                    )
                                    .font(.headline)
                                    .italic()
                                    .bold()
                                    .padding(.bottom, 2)
                                    Text(
                                        self.promptAndResponses[index]?
                                            .response ?? "No response"
                                    )
                                    .opacity(0.8)
                                    .padding(.bottom, 12)
                                }
                                Spacer()
                                Image(systemName: "pencil")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color.jAccent)
                                    .bold()
                                    .padding(12)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .inset(by: 3)  // inset value should be same as lineWidth in .stroke
                                    .stroke(
                                        Color.jAccent, lineWidth: 3
                                    )
                            )

                        }
                    )
                    .buttonStyle(.plain)
                    .opacity(
                        self.promptAndResponses[index]?.response
                            == nil ? 0 : 1)

                }
            }
        }
    }
}

#Preview {
    PromptListView(
        promptAndResponses: [
            nil,
            PromptOptionAndResponse(
                option: PromptOption(prompt: "What is your favorite memory?"),
                response:
                    "how to ride bicycle kind of trend of why I'm not learning in my childhood what are you for skill"
            ), nil,
        ],
        onChooseNewPrompt: { index in
            print("New prompt for \(index)")
        },
        onUpdatePrompt: { index in
            print("Update prompt for \(index)")
        }
    )
}
