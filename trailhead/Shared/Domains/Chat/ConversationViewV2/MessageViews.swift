//
//  UserMessageView.swift
//  trailhead
//
//  Created by Robin Götz on 3/10/25.
//
import SwiftUI

struct UserMessageView: View {
    let message: String
    var body: some View {
        HStack {
            Spacer()
            Text(message)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                }
                .frame(maxWidth: 300, alignment: .trailing)
                .fixedSize(horizontal: false, vertical: true)
        }.frame(maxWidth: .infinity)
    }
}

struct MentorMessageView: View {
    let message: String
    let isComplete: Bool
    let isError: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(message)
                .multilineTextAlignment(.leading)
            if !isError {
                HStack {
                    CopyButton(textToCopy: message)
                }
                .padding(10)
                .opacity(self.isComplete ? 1 : 0)
                .disabled(!self.isComplete)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ErrorMessageView: View {
    let onErrorMessageTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
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
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct StreamingMessageWithPlaceholderView: View {
    let mentorMessage: String
    let userMessage: String
    let isWaitingForStreamToStart: Bool
    let isStreamCompleted: Bool
    let isMakingRoomForStream: Bool
    let isUserMessageInternal: Bool
    let isError: Bool
    let onErrorMessageTap: () -> Void
    let scrollViewHeight: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if !isUserMessageInternal {
                UserMessageView(message: userMessage)
            }
            if isWaitingForStreamToStart {
                HStack {
                    PulsingCircle()
                    Spacer()
                }
            } else {
                VStack {
                    if !self.mentorMessage.isEmpty {
                        MentorMessageView(
                            message: self.mentorMessage,
                            isComplete: self.isStreamCompleted,
                            isError: self.isError
                        )
                    }
                    if isError {
                        ErrorMessageView(onErrorMessageTap: self.onErrorMessageTap)
                    }
                }

            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: self.isMakingRoomForStream ? scrollViewHeight : nil,
            alignment: .topTrailing
        )
    }
}
