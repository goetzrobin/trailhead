//
//  MessageBubbleView.swift
//  trailhead
//
//  Created by Robin Götz on 2/6/25.
//

import SwiftUI

struct MessageBubbleView: View {
    let viewModel: MessageViewModel
    let onErrorMessageTap: () -> Void
    @State private var collapsed = true

    var body: some View {
        HStack {
            if viewModel.type == .userMessage {
                Spacer()
            }

            VStack(alignment: .leading) {
                 if viewModel.type == .aiMessage {
                     VStack(alignment: .leading) {
                         Text(viewModel.content)
                             .textSelection(.enabled)
                             .padding()
                             .background(.secondary.opacity(0.1))
                             .cornerRadius(12)
                             .opacity(viewModel.message.hasError ? 0.4 : 1)
                         if viewModel.message.hasError {
                             Button(action: self.onErrorMessageTap, label: {
                                 HStack {
                                     Text("Hmmm... Something went wrong.\nTap to try again")
                                         .multilineTextAlignment(.leading)
                                     Image(systemName: "arrow.counterclockwise")
                                 }
                             })
                             .buttonStyle(.bordered)
                             .tint(.red)
                             .padding(.top, 5)
                         }
                     }
                    
                } else {
                    Text(viewModel.content)
                        .textSelection(.enabled)
                        .padding()
                        .background(Color.jAccent.opacity(0.2))
                        .cornerRadius(12)
                }
            }

            if viewModel.type == .aiMessage {
                Spacer()
            }
        }
    }

}

#Preview {
    // Preview with stored message
    let storedMessage = StoredMessage(
        id: "test-stored",
        content: "This is a test message",
        type: .userMessage,
        scope: .external,
        createdAt: Date(),
        formatVersion: .v1,
        currentStep: nil,
        stepRepetitions: nil
    )

    let storedViewModel = MessageViewModel(
        message: storedMessage,
        streamState: .stored
    )

    // Preview with streaming message
    let streamingMessage = StreamingMessage(
        id: "test-streaming",
        content: "<think>Processing user request</think>Here is the response",
        type: .aiMessage,
        scope: .external,
        createdAt: Date(),
        runId: "test-run",
        currentStep: nil,
        stepRepetitions: nil
    )
    
    let streamingViewModel = MessageViewModel(
        message: streamingMessage,
        streamState: .streaming(.idle)
    )

    VStack(spacing: 20) {
        MessageBubbleView(viewModel: storedViewModel) { print("Retry")}
        MessageBubbleView(viewModel: streamingViewModel) { print("Retry")}
    }
    .padding()
}
