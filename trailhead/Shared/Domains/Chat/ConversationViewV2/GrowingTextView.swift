//
//  GrowingTextView.swift
//  trailhead
//
//  Created by Robin Götz on 3/9/25.
//
import SwiftUI

fileprivate let INITIAL_HEIGHT: CGFloat = 38

struct GrowingTextView: View {
    @FocusState.Binding var isFocused: Bool
    let isEndConversationEnabled: Bool
    let onEndConversation: () -> Void
    let onSend: (String) -> Void
    
    
    @State private var text: String = ""
    @State private var textViewHeight: CGFloat = INITIAL_HEIGHT
    @State private var isShowingFullViewMessageSheet = false
    @State private var isShowingSurvey = true

    // Constants for styling
    private let minHeight: CGFloat = INITIAL_HEIGHT
    private let maxHeight: CGFloat = 240
    private let cornerRadius: CGFloat = 24
    
    var isTextEmpty: Bool {
        self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack {
                HStack(alignment: .top) {
                    if !isShowingFullViewMessageSheet {
                        UITextViewWrapper(
                            text: $text,
                            calculatedHeight: $textViewHeight,
                            minHeight: minHeight,
                            maxHeight: maxHeight
                        )
                        .focused($isFocused)
                        .frame(
                            height: max(
                                minHeight,
                                min(textViewHeight, maxHeight)
                            )
                        )
                        .padding(.top, 12)
                    }
                                    
                    if textViewHeight > 60 {
                        ExpandTextEditorButton(onTap: self.openSheet)
                    }
                }
                .padding(.horizontal, 12)
                             
                ActionButtons(
                    isTextEmpty: isTextEmpty,
                    isEndConversationEnabled: self.isEndConversationEnabled,
                    isSendMessageEnabled: !isTextEmpty,
                    onEndConversation: self.onEndConversation,
                    onSendMessage: { self.sendMessage()}
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
        .background {
            RoundedCornerShape(
                radius: cornerRadius,
                corners: [.topLeft, .topRight]
            )
            .fill(.thinMaterial)
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .sheet(
            isPresented: self.$isShowingFullViewMessageSheet,
            onDismiss: onDismissSheet
        ) {
            ExpandedTextEditorSheet(
                text: $text,
                isPresented: $isShowingFullViewMessageSheet,
                onSend: self.sendMessage,
                onDismissSheet: self.onDismissSheet
            )
        }
    }
    
    private func openSheet() {
        isShowingFullViewMessageSheet = true
    }
    
    private func onDismissSheet() {
        isFocused = true
    }
    
    private func sendMessage() {
        self.onSend(text)
        text = ""
        textViewHeight = INITIAL_HEIGHT
    }
}

struct ExpandTextEditorButton: View {
    let onTap: () -> Void
    var body: some View {
        Button(
            action: self.onTap,
            label: {
                Label(
                    "Expand Textfield",
                    systemImage: "arrow.down.backward.and.arrow.up.forward"
                )
                .bold()
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .labelStyle(.iconOnly)
                
            })
        .buttonStyle(.plain)
        .padding(.trailing, 8)
        .padding(.top, 16)
    }
}

struct ExpandedTextEditorSheet: View {
    @Binding var text: String
    @Binding var isPresented: Bool
    var onSend: () -> Void
    var onDismissSheet: () -> Void

    @FocusState private var isFocused: Bool
    
    // Function to handle dismissing the sheet
    private func dismissSheet() {
        onDismissSheet()
        isPresented = false
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(
                    action: {
                        dismissSheet()
                    },
                    label: {
                        Label(
                            "Close Textfield",
                            systemImage: "arrow.up.forward.and.arrow.down.backward"
                        )
                        .bold()
                        .frame(width: 12, height: 20)
                        .labelStyle(.iconOnly)
                    })
                .buttonStyle(.plain)
            }
            TextEditor(text: $text)
                .focused($isFocused)
                .frame(minHeight: 200)
            HStack {
                Spacer()
                Button(
                    action: {
                        onSend()
                        dismissSheet()
                    },
                    label: {
                        Label(
                            "Send message",
                            systemImage: "arrow.up"
                        )
                        .bold()
                        .frame(width: 12, height: 20)
                        .labelStyle(.iconOnly)
                    })
                .cornerRadius(50)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .onAppear {
            isFocused = true
        }
    }
}

struct ActionButtons: View {
    let isTextEmpty: Bool
    let isEndConversationEnabled: Bool
    let isSendMessageEnabled: Bool
    var onEndConversation: () -> Void
    var onSendMessage: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: onEndConversation, label: {
                Label {
                    Text("End Conversation")
                } icon: {
                    Image(systemName: "hand.wave.fill")
                        .accessibilityHidden(true)
                }
                .bold()
                .font(.system(size: 12))
            })
            .cornerRadius(50)
            .buttonStyle(.bordered)
            .disabled(!isEndConversationEnabled)
            .opacity(isEndConversationEnabled ? 1: 0.5)
            Spacer()
            Button(action: onSendMessage, label: {
                if !isTextEmpty {
                    Label("Send", systemImage: "arrow.up")
                        .bold()
                        .frame(width: 8, height: 18)
                        .labelStyle(.iconOnly)
                }    else {
                    Label("Send", systemImage: "arrow.up")
                        .bold()
                        .font(.system(size: 13))
                        .frame(height: 18)
                        .labelStyle(.titleOnly)
                }
            })
            .cornerRadius(50)
            .buttonStyle(.borderedProminent)
            .disabled(!isSendMessageEnabled)
        }
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


// Preview Provider
#Preview {
    @Previewable @FocusState var isFocused: Bool
    GrowingTextView(isFocused: $isFocused, isEndConversationEnabled: true, onEndConversation: {} ,onSend: { message in
        print(message)
    })
}
