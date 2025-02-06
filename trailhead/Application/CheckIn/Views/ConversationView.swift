import SwiftUI

struct ConversationView: View {
    @State private var viewModel = ChatMessageStore()
    @State private var newMessage: String = ""
    @Namespace private var bottomID
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    // Main message list
                    ForEach(viewModel.messages, id: \.id) { messageViewModel in
                        MessageBubbleView(viewModel: messageViewModel)
                            .id(messageViewModel.id) // Use message ID for animations
                            .transition(.opacity) // Smooth appearance
                    }
                    
                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    // Invisible anchor view for scrolling
                    Color.clear
                        .frame(height: 1)
                        .id(bottomID)
                }
                .padding()
            }
            .onChange(of: viewModel.messages.count) { oldCount, newCount in
                // Scroll on new message
                withAnimation {
                    proxy.scrollTo(bottomID)
                }
            }
            .onChange(of: viewModel.messages.last?.content) { oldContent, newContent in
                // Scroll on content update during streaming
                withAnimation {
                    proxy.scrollTo(bottomID)
                }
            }
        }
        
        // Input area
        HStack {
            TextField("Type a message...", text: $newMessage)
                .textFieldStyle(.roundedBorder)
                .disabled(viewModel.isStreaming)
                .submitLabel(.send)
                .onSubmit {
                    sendMessage()
                }
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title)
                    .symbolEffect(.bounce, isActive: viewModel.isStreaming)
            }
            .disabled(newMessage.isEmpty || viewModel.isStreaming)
        }
        .padding()
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let messageToSend = newMessage
        newMessage = "" // Clear input immediately for better UX
        
        Task {
            await viewModel.sendMessage(with: messageToSend)
        }
    }
}

// MARK: - Preview
#Preview {
    ConversationView()
}
