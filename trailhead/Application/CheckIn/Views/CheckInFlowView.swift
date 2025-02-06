//
//  CheckInFlowView.swift
//  trailhead
//
//  Created by Robin Götz on 2/5/25.
//

import SwiftUI

struct CheckInFlowView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var isPromptFocused: Bool
    @State var isLLMRunnning: Bool = false
    @State var isLLMCanceled: Bool = false
    @State var prompt = ""

    let platformBackgroundColor: Color = {
        return Color(UIColor.secondarySystemBackground)
    }()

    var isPromptEmpty: Bool {
        prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var generateButton: some View {
        Button {
            generate()
        } label: {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                #if os(iOS) || os(visionOS)
                    .frame(width: 24, height: 24)
                #else
                    .frame(width: 16, height: 16)
                #endif
        }
        .disabled(self.isPromptEmpty)
        .padding(.trailing, 12)
        .padding(.bottom, 12)

    }

    var stopButton: some View {
        Button {
            stop()
        } label: {
            Image(systemName: "stop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
        }
        .disabled(self.isLLMCanceled)
        .padding(.trailing, 12)
        .padding(.bottom, 12)
    }

    var chatInput: some View {
        HStack(alignment: .bottom, spacing: 0) {
            TextField("message", text: self.$prompt, axis: .vertical)
                .focused(self.$isPromptFocused)
                .textFieldStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(minHeight: 48)

                .onSubmit {
                    self.isPromptFocused = true
                    self.generate()
                }

            if self.isLLMRunnning {
                stopButton
            } else {
                generateButton
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(platformBackgroundColor)
        )

    }

    func generate() {
        print("Generating")
        self.isLLMRunnning = true
    }

    func stop() {
        print("Stopping")
        self.isLLMCanceled = true
    }

    var body: some View {
        Text( /*@START_MENU_TOKEN@*/"Hello, World!" /*@END_MENU_TOKEN@*/)
        Button("Dismiss") {
            self.dismiss()
        }
        Spacer()
        chatInput
    }
}

#Preview {
    CheckInFlowView()
}
