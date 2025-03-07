import SwiftUI

struct Shake: GeometryEffect {
    var shakesPerUnit = 4
    var animatableData: CGFloat
    var anchor: UnitPoint = .center  // Add anchor point

    func effectValue(size: CGSize) -> ProjectionTransform {
        let angle = 0.045 * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        let anchorPoint = CGPoint(
            x: size.width * anchor.x, y: size.height * anchor.y)

        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: anchorPoint.x, y: anchorPoint.y)
        transform = transform.rotated(by: angle)
        transform = transform.translatedBy(x: -anchorPoint.x, y: -anchorPoint.y)

        return ProjectionTransform(transform)
    }
}

// MARK: - Main View
struct ConversationView: View {
    @Environment(\.dismiss) var dismiss

    @State private var viewModel: ChatMessageStore
    @State private var newMessage: String = ""
    @State private var showTextField = false
    @State private var isInitialLoadComplete = false
    @Namespace private var bottomID

    private var slug: String
    private var userId: UUID
    private var sessionLogId: UUID?
    private var sessionLogStatus: SessionLog.Status?
    private var maxSteps: Int?
    private var delayInMs: Int
    private var isShowingXButton: Bool = false
    private var customEndConversationLabel: String?
    private var onSessionEnded: (() -> Void)?

    private var isNewMessageEmpty: Bool {
        newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @State private var isShowingStartConvoModal = false
    @State private var isAboutToStartConversation = false
    @State private var isShowingEndConvoModal = false
    @State private var isConversationEnded = false
    @State private var isShowingEndConversationButton = false
    @State private var shakeCount = 0

    init(
        sessionApiClient: SessionAPIClient,
        authProvider: AuthorizationProvider,
        slug: String,
        userId: UUID,
        sessionLogId: UUID?,
        delayInMs: Int? = 300,
        maxSteps: Int? = nil,
        sessionLogStatus: SessionLog.Status? = .inProgress,
        isShowingXButton: Bool = false,
        customEndConversationLabel: String? = nil,
        onSessionEnded: (() -> Void)? = nil
    ) {
        let viewModel = ChatMessageStore(
            sessionApiClient: sessionApiClient,
            authProvider: authProvider, userId: userId,
            slug: slug, sessionLogId: sessionLogId)
        self.viewModel = viewModel
        self.slug = slug
        self.userId = userId
        self.sessionLogId = sessionLogId
        self.sessionLogStatus = sessionLogStatus
        self.delayInMs = delayInMs ?? 300
        self.maxSteps = maxSteps
        self.isShowingXButton = isShowingXButton
        self.customEndConversationLabel = customEndConversationLabel
        self.onSessionEnded = onSessionEnded
    }

    var body: some View {
        ZStack {
            if self.sessionLogId != nil && !self.isInitialLoadComplete {
                ConversationLoadingView()
            }

            VStack(alignment: .leading) {
                if isShowingXButton {
                    CloseHeader {
                        if (self.isConversationEnded) {
                            self.dismiss()
                        } else {
                            self.isShowingEndConvoModal = true
                        }
                    }
                }
                ConversationMessageList(
                    viewModel: viewModel,
                    isInitialLoadComplete: $isInitialLoadComplete,
                    showTextField: $showTextField,
                    bottomID: bottomID,
                    initialDelay: delayInMs
                )
                

                if self.sessionLogStatus == .inProgress && !isConversationEnded {
                    ZStack(alignment: .topTrailing) {
                        Button(action: {
                            self.isShowingEndConvoModal = true
                        }) {
                            Text("End conversation")
                        }.buttonStyle(
                            .jAccent(horizontalPadding: 14, verticalPadding: 6)
                        )
                        .modifier(Shake(animatableData: CGFloat(shakeCount)))
                        .offset(
                            x: -20,
                            y: self.isShowingEndConversationButton ? -34 : 0
                        )
                        .opacity(self.isShowingEndConversationButton ? 1 : 0)

                        ChatTextFieldView(
                            newMessage: self.$newMessage,
                            isNewMessageEmpty: isNewMessageEmpty,
                            viewModel: self.viewModel,
                            onSendMessage: self.sendMessage,
                            onCancelMessage: self.cancelMessage
                        )
                    }
                    .opacity(self.showTextField ? 1 : 0)
                    .padding()
                }
            }
        }
        .onAppear {
            if self.sessionLogId != nil {
                self.viewModel.loadInitialMessages()
            } else {
                self.isShowingStartConvoModal = true
            }
        }
        .onChange(of: viewModel.messages.last?.message.currentStep) { _, _ in
            showEndConversationButtonOrShake()
        }
        .onChange(of: isInitialLoadComplete) { oldValue, newValue in
            if oldValue == false && newValue == true {
                if viewModel.messages.count == 0 {
                    Task {
                        await self.viewModel.haveSamReachOut()
                    }
                }
            }
        }
        .sheet(
            isPresented: $isShowingStartConvoModal,
            onDismiss: {
                if !isAboutToStartConversation {
                    self.dismiss()
                }
            },
            content: {
                SessionQuestionnaire(
                    completeDescription:
                        "Let's start today's conversation! Sam's already waiting for you!",
                    completeButtonText: "Start Conversation",
                    isLoading: self.viewModel.startSessionStatus == .loading
                ) { scores in
                    isAboutToStartConversation = true
                    // hit endpoint
                    self.viewModel.startSession(with: scores) { _ in
                        isShowingStartConvoModal = false
                        self.viewModel.refreshSessionsAndLogs()
                        // sam is going to reach out because of initial load marked as completed!
                    }
                }
                .presentationDetents([.height(270)])
                .presentationBackground(.ultraThinMaterial)
            }
        )
        .sheet(
            isPresented: $isShowingEndConvoModal,
            content: {
                SessionQuestionnaire(
                    completeDescription:
                        "Thanks for answering all of Sam's questions!",
                    completeButtonText: customEndConversationLabel ?? "End Conversation",
                    isLoading: self.viewModel.endSessionStatus == .loading
                ) { scores in
                    self.viewModel.endSession(with: scores) { _ in
                        self.viewModel.refreshSessionsAndLogs()
                        isShowingEndConvoModal = false
                        isConversationEnded = true
                        onSessionEnded?()
                    }
                }
                .presentationDetents([.height(270)])
                .presentationBackground(.ultraThinMaterial)
            })
    }

    private func showEndConversationButtonOrShake() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + .milliseconds(1500)
        ) {
            let currentStep = viewModel.messages.last?.message.currentStep
            let alreadyShowing = self.isShowingEndConversationButton
            withAnimation {
                self.isShowingEndConversationButton =
                    alreadyShowing
                    || (currentStep != nil && maxSteps != nil
                        && currentStep == maxSteps)
                if isShowingEndConversationButton {
                    self.shakeCount += 1
                }
            }
        }
    }

    private func cancelMessage() {
        viewModel.cancelStream()
    }

    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let messageToSend = newMessage
        newMessage = ""  // Clear input immediately for better UX

        Task {
            await viewModel.sendMessage(with: messageToSend)
        }
    }
}

// MARK: - Conversation Components

/// Displays the messages in a scrollable container
struct ConversationMessageList: View {
    let viewModel: ChatMessageStore
    @Binding var isInitialLoadComplete: Bool
    @Binding var showTextField: Bool
    let bottomID: Namespace.ID
    let initialDelay: Int

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 12) {
                    // Main message list
                    ForEach(viewModel.messages, id: \.id) { messageViewModel in
                        if messageViewModel.message.scope == .internal {
                            EmptyView()
                        }
                        else {
                            MessageBubbleView(viewModel: messageViewModel) {
                                Task {
                                   await self.viewModel.retryOnError()
                                }
                            }
                                .id(messageViewModel.id)
                                .transition(.opacity)
                        }
                    }

                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }

                    if viewModel.isPreparingMessageStream {
                        TypingIndicator()
                    }

                    // Invisible anchor view for scrolling
                    Color.clear
                        .frame(height: 1)
                        .id(bottomID)
                }
                .padding()
                .modifier(
                    ConversationAppearanceModifier(
                        isInitialLoadComplete: $isInitialLoadComplete,
                        showTextField: $showTextField,
                        initialDelay: initialDelay
                    ))
            }
            .modifier(
                ConversationScrollModifier(
                    isLoadingMessages: .init(
                        get: { viewModel.isLoadingStoredMessages },
                        set: { _ in }),
                    isInitialLoadComplete: $isInitialLoadComplete,
                    messages: viewModel.messages,
                    messageCount: viewModel.messages.count,
                    latestMessageContent: viewModel.messages.last?.content,
                    bottomID: bottomID,
                    initialDelay: initialDelay,
                    proxy: proxy
                ))
        }
        .scrollDismissesKeyboard(.interactively)
    }

}

/// Loading indicator shown while messages are being loaded
struct ConversationLoadingView: View {
    var body: some View {
        ProgressView()
    }
}

// MARK: - Chat Text Field
struct ChatTextFieldView: View {
    @Binding var newMessage: String
    let isNewMessageEmpty: Bool
    let viewModel: ChatMessageStore
    let onSendMessage: () -> Void
    let onCancelMessage: () -> Void

    var body: some View {
        HStack {
            TextField("Type a message...", text: $newMessage)
                .textFieldStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(minHeight: 48)
                .disabled(viewModel.isPreparingMessageStream)
                .submitLabel(.send)
                .onSubmit {
                    if !isNewMessageEmpty && !viewModel.isPreparingMessageStream {
                        onSendMessage()
                    }
                }

            Button(
                action: onSendMessage
            ) {
                Image(
                    systemName: "arrow.up.circle.fill"
                )
                .font(.title)
            }
            .disabled(isNewMessageEmpty || viewModel.isPreparingMessageStream)
            .padding(.trailing, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.platformBackgroundColor)
        )
    }
}

// MARK: - View Modifiers

/// Handles auto-scrolling behavior for the conversation
struct ConversationScrollModifier: ViewModifier {
    @Binding var isLoadingMessages: Bool
    @Binding var isInitialLoadComplete: Bool
    let messages: [MessageViewModel]
    let messageCount: Int
    let latestMessageContent: String?
    let bottomID: Namespace.ID
    let initialDelay: Int
    let proxy: ScrollViewProxy

    func body(content: Content) -> some View {
        content
            .onChange(of: isLoadingMessages) { oldValue, newValue in
                // Messages started loading - perform scroll because input lost focus and keyboard most likely got hidden
                    // Messages finished loading - perform initial scroll
                    handleInitialScroll()
                       }
            .onChange(of: messageCount) { _, _ in
                if isInitialLoadComplete {
                    scrollToBottom()
                }
            }
            .onChange(of: latestMessageContent) { _, _ in
                if isInitialLoadComplete {
                    scrollToBottom()
                }
            }
    }

    private func handleInitialScroll() {
        scrollToBottom(animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            withAnimation {
                isInitialLoadComplete = true
            }
        }
    }

    private func scrollToBottom(animated: Bool = true) {
        if animated {
            withAnimation {
                proxy.scrollTo(bottomID)
            }
        } else {
            proxy.scrollTo(bottomID)
        }
    }
}

/// Manages appearance of messages and input field
struct ConversationAppearanceModifier: ViewModifier {
    @Binding var isInitialLoadComplete: Bool
    @Binding var showTextField: Bool
    let initialDelay: Int

    func body(content: Content) -> some View {
        content
            .opacity(isInitialLoadComplete ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + .milliseconds(initialDelay)
                ) {
                    withAnimation {
                        showTextField = true
                    }
                }
            }
    }
}


struct TypingIndicator: View {
    // Animation states
    @State private var firstDotOffset: CGFloat = 0
    @State private var secondDotOffset: CGFloat = 0
    @State private var thirdDotOffset: CGFloat = 0
    
    @State private var firstDotOpacity: Double = 0.4
    @State private var secondDotOpacity: Double = 0.4
    @State private var thirdDotOpacity: Double = 0.4
    
    var body: some View {
        HStack(spacing: 5) {
            DotView(offset: firstDotOffset, opacity: firstDotOpacity)
            DotView(offset: secondDotOffset, opacity: secondDotOpacity)
            DotView(offset: thirdDotOffset, opacity: thirdDotOpacity)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .onAppear {
            animateDots()
        }
    }
    
    // DotView is a single dot in the typing indicator
    private struct DotView: View {
        let offset: CGFloat
        let opacity: Double
        
        var body: some View {
            Circle()
                .frame(width: 8, height: 8)
                .foregroundStyle(.foreground)
                .opacity(opacity)
                .offset(y: offset)
        }
    }
    
    // Start the dot animations with different timing
    private func animateDots() {
        // First dot animation
        withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            firstDotOffset = -2
            firstDotOpacity = 0.9
        }
        
        // Second dot animation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                secondDotOffset = -3
                secondDotOpacity = 0.9
            }
        }
        
        // Third dot animation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                thirdDotOffset = -2
                thirdDotOpacity = 0.9
            }
        }
    }
}


// MARK: - Preview
#Preview {
    let authStore = AuthStore()
    ConversationView(
        sessionApiClient: SessionAPIClient(authProvider: authStore),
        authProvider: authStore, slug: "test-v0", userId: UUID(),
        sessionLogId: UUID())
}
