//
//  ConversationViewV2.swift
//  trailhead
//
//  Created by Robin Götz on 3/9/25.
//
import SwiftUI
import Observation

struct ConversationViewV2: View {
    // Dependencies
    @State private var sessionManagementViewModel: SessionManagementViewModel
    @State private var chatMessageViewModel: ChatMessageViewModel

    // Required properties
    private let slug: String
    private let userId: UUID
    
    // Optional properties with defaults
    private var maxSteps: Int?
    private var customEndConversationLabel: String?
    private var isAutoStartingWithoutPreSurvey: Bool = false
    
    let onPostSurveySuccess: (() -> Void)?
    let onNotNow: (() -> Void)?
    let skipOnNotNowPreSurveySheetDismiss: Bool

    // State
    @State private var scrollViewHeight: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    @FocusState private var isFocused: Bool
    @State private var reply: String = ""
    @State private var isEndConversationEnabled = false
    @State private var isShowingTextView = false
    @State private var isShowingMessageView = false
    
    private var currentStep: Int {
        self.chatMessageViewModel.messagePairs.first?.chunks?.last?.currentStep ?? 0
    }

    private var isShowingScrollToBottomButton: Bool {
        scrollOffset < -20.0 &&
        !self.chatMessageViewModel.isLoadingExistingMessages &&
        self.chatMessageViewModel.messagePairs.count > 0
    }
    
    init(config: ConversationConfig) {
        self.slug = config.slug
        self.userId = config.userId
        self.maxSteps = config.maxSteps
        self.customEndConversationLabel = config.customEndConversationLabel
        
        self.sessionManagementViewModel = SessionManagementViewModel(
            sessionAPIClient: config.sessionApiClient,
            slug: self.slug,
            userId: self.userId,
            sessionLogId: config.sessionLogId,
            sessionLogStatus: config.sessionLogStatus
        )
        self.chatMessageViewModel = ChatMessageViewModel(
            messageAPIClient: ChatMessageAPIClient(
                authProvider: config.authProvider
            ),
            userId: self.userId,
            slug: self.slug
        )

        self.isAutoStartingWithoutPreSurvey = config.isAutoStartingWithoutPreSurvey
        
        self.onPostSurveySuccess = config.onSessionEnded
        self.onNotNow = config.onNotNow
        self.skipOnNotNowPreSurveySheetDismiss = config.skipOnNotNowPreSurveySheetDismiss
    }
    
    private func onNotNowWithDelayTakenIntoAccount() {
        guard let onNotNow = onNotNow else {
            return
        }
        if skipOnNotNowPreSurveySheetDismiss {
            self.sessionManagementViewModel.hidePreSurvey()
            onNotNow()
        } else {
            self.sessionManagementViewModel.hidePreSurvey()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onNotNow()
            }
        }
    }
    
    private func handleOnAppear() {
        if let sessionLogId = self.sessionManagementViewModel.sessionLogId {
            print(
                "[ConversationView2] loading initial messages for \(sessionLogId.uuidString)"
            )
            if isAutoStartingWithoutPreSurvey {
                self.isShowingMessageView = true
                self.isShowingTextView = true
                self.chatMessageViewModel.haveSamReachOut()
            } else {
                self.chatMessageViewModel.fetchStoredMessages(for: sessionLogId)
            }
        } else {
            print(
                "[ConversationView2] no session log id, showing pre survey to start session with slug \(self.slug)"
            )
            self.sessionManagementViewModel.showPreSurvey()
        }
        
        self.updateEndConversationBasedOnMaxSteps(currentStep: self.currentStep)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                self.isShowingMessageView = true
            }
        }
    }
    
    
    private func handleOnPreSurveySuccess() {
        withAnimation {
            self.isShowingTextView = true
        }
        self.chatMessageViewModel.haveSamReachOut()
    }
    
    private func handleOnLoadingExistingMessagesChange(_ isLoading: Bool) {
        print("[ConversationView2] isLoadingExistingMessagesChange: \(isLoading) \(self.sessionManagementViewModel.sessionLogStatus)")
        if !isLoading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    self.isShowingMessageView = true
                    if self.sessionManagementViewModel.sessionLogStatus == .inProgress {
                        self.isShowingTextView = true
                    }
                }
            }
        }
    }
    
    private func handleOnScrollToBottom() {
        print("[ConversationView2] scrolling to bottom of the chat")
        withAnimation {
            if let proxy = scrollProxy {
                proxy.scrollTo("bottom")
            }
        }
    }
    
    private func handleOnErrorMessageTap(index: Int) {
        self.chatMessageViewModel.retry(index: index)
    }
    
    private func updateEndConversationBasedOnMaxSteps(currentStep: Int) {
        print("[ConversationView2] updating if user can end conversation based on currentStep:\(currentStep) and maxSteps:\(maxSteps ?? -1)")
        self.isEndConversationEnabled =
        // if we are already enabled once we don't go back
        self.isEndConversationEnabled ||
        // if no max steps always enabled else need to reach max steps
        (self.maxSteps == nil || self.maxSteps == currentStep)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if self.chatMessageViewModel.isLoadingExistingMessages {
                ProgressView().padding(.top, UIScreen.main.bounds.height * 0.3)
                    .tint(.secondary)
            }
            ConversationWrapperView(
                sessionManagementViewModel: self.sessionManagementViewModel,
                handleOnAppear: self.handleOnAppear,
                onNotNow: self.onNotNow != nil ? self.onNotNowWithDelayTakenIntoAccount : nil,
                onPreSurveySuccess: self.handleOnPreSurveySuccess,
                onPostSurveySuccess: self.onPostSurveySuccess
            ) {
               ChatList(
                    scrollViewHeight: self.$scrollViewHeight,
                    contentHeight: self.$contentHeight,
                    scrollOffset: self.$scrollOffset,
                    scrollProxy: self.$scrollProxy
                ) {
                    
                    // we are inversed so bottom is first element
                    Color.clear.frame(height: 1).id("bottom")
                    
                    ForEach(
                        Array(
                            self.chatMessageViewModel.messagePairs.enumerated()
                        ),
                        id: \.element.id
                    ) { index, messagePair in
                        MessageInListView(
                            messagePair: messagePair,
                            isFirstMessagePair: index == 0,
                            onErrorMessageTap: { self.handleOnErrorMessageTap(index: index) },
                            scrollViewHeight: self.scrollViewHeight)
                    }
                    
                }
                .opacity(self.isShowingMessageView ? 1 : 0)
                .onChange(of: self.chatMessageViewModel.isLoadingExistingMessages) { _, newValue in
                    self.handleOnLoadingExistingMessagesChange(newValue)
                }
                .onChange(of: self.currentStep) { _, newValue in
                    self.updateEndConversationBasedOnMaxSteps(currentStep: newValue)
                }
                .onTapGesture {
                    self.isFocused = false
                }
                .overlay(alignment: .bottom) {
                    if isShowingScrollToBottomButton {
                        ScrollToBottomButton(onTap: self.handleOnScrollToBottom)
                    }
                }
                if (sessionManagementViewModel.sessionLogId == nil || sessionManagementViewModel.sessionLogStatus == .inProgress) {
                    GrowingTextView(
                        isFocused: $isFocused,
                        isEndConversationEnabled: self.isEndConversationEnabled,
                        customEndConversationLabel: customEndConversationLabel,
                        onEndConversation: self.sessionManagementViewModel.handleOnEndConversation,
                        onSend: {  message in self.chatMessageViewModel.sendMessage(message)
                        }
                    ).opacity(self.isShowingTextView ? 1 : 0)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
    }
}

struct MessageInListView: View {
    let messagePair: MessagePair
    let isFirstMessagePair: Bool
    let onErrorMessageTap: () -> Void
    let scrollViewHeight: CGFloat
    var body: some View {
        if messagePair.isPair, let aiMessage = messagePair.aiMessage, let userMessage = messagePair.userMessage {
            StreamingMessageWithPlaceholderView(
                mentorMessage: aiMessage,
                userMessage: userMessage,
                isWaitingForStreamToStart: messagePair.isWaitingForStreamToStart,
                isStreamCompleted: messagePair.isComplete,
                isMakingRoomForStream: isFirstMessagePair,
                isUserMessageInternal: messagePair.isUserMessageInternal,
                isError: messagePair.isError,
                onErrorMessageTap: onErrorMessageTap,
                scrollViewHeight: scrollViewHeight
            )
        } else if let aiMessage = messagePair.aiMessage {
            MentorMessageView(
                message: aiMessage,
                isComplete: messagePair.isComplete,
                isError: messagePair.isError
            )
        } else if let userMessage = messagePair.userMessage {
            UserMessageView(message: userMessage)
                .padding(.bottom, 24)
        }
    }
}

struct ConversationWrapperView<Content: View>: View {
    let content: Content
    let sessionManagementViewModel: SessionManagementViewModel
    let onNotNow: (() -> Void)?
    let onPreSurveySuccess: (() -> Void)?
    let onPostSurveySuccess: (() -> Void)?
    let handleOnAppear: () -> Void
        
    init(
        sessionManagementViewModel: SessionManagementViewModel,
        handleOnAppear: @escaping () -> Void,
        onNotNow: (() -> Void)?,
        onPreSurveySuccess: (() -> Void)?,
        onPostSurveySuccess: (() -> Void)?,
        @ViewBuilder content: () -> Content) {
            self.sessionManagementViewModel = sessionManagementViewModel
            self.handleOnAppear = handleOnAppear
            self.onNotNow = onNotNow
            self.onPreSurveySuccess = onPreSurveySuccess
            self.onPostSurveySuccess = onPostSurveySuccess
            
            self.content = content()
        }
    
    var body: some View {
        VStack {
            content
        }
        .sheet(isPresented:
                Binding(get: {
            self.sessionManagementViewModel.isShowingPreSurvey
        }, set: {_ in})
        ) {
            SurveyView(
            variant: .pre,
            isLoading: self.sessionManagementViewModel.isSessionStartLoading,
            onNotNow: onNotNow
        ) { feeling, anxiety, motivation in
            self.sessionManagementViewModel.handlePreSurveySubmission(
                feeling: feeling,
                anxiety: anxiety,
                motivation: motivation,
                onSuccess: self.onPreSurveySuccess
            )
        }
        .surveySheet()
        }
        .sheet(isPresented:
                Binding(get: {
            self.sessionManagementViewModel.isShowingPostSurvey
        }, set: {_ in })
        ) {
            SurveyView(
                variant: .post,
                isLoading: self.sessionManagementViewModel.isSessionEndLoading
            ) { feeling, anxiety, motivation in
                self.sessionManagementViewModel.handlePostSurveySubmission(
                    feeling: feeling,
                    anxiety: anxiety,
                    motivation: motivation,
                    onSuccess: self.onPostSurveySuccess
                )
            }
            .surveySheet(isDismissable: true)
        }
        .onAppear(perform: self.handleOnAppear)
    }
}


#Preview {
    let authStore = AuthStore()
    let config = ConversationConfig(
        sessionApiClient: SessionAPIClient(authProvider: authStore),
        authProvider: authStore, slug: "test-v0", userId: UUID(),
        sessionLogId: nil)
    ConversationViewV2(config: config)
}
