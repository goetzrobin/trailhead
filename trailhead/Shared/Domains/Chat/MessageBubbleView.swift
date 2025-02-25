//
//  MessageBubbleView.swift
//  trailhead
//
//  Created by Robin Götz on 2/6/25.
//

import SwiftUI

struct MessageBubbleView: View {
    let viewModel: MessageViewModel
    @State private var collapsed = true

    var body: some View {
        HStack {
            if viewModel.type == .userMessage {
                Spacer()
            }

            VStack(alignment: .leading) {
                if viewModel.type == .aiMessage {
                    Text(viewModel.content)
                        .padding()
                        .background(.secondary.opacity(0.1))
                        .cornerRadius(12)

                } else {
                    Text(viewModel.content)
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
        MessageBubbleView(viewModel: storedViewModel)
        MessageBubbleView(viewModel: streamingViewModel)
    }
    .padding()
}
