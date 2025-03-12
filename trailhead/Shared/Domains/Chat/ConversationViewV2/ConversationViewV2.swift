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

    // State
    @State private var scrollViewHeight: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    @FocusState private var isFocused: Bool
    @State private var reply: String = ""
    @State private var isEndConversationEnabled = true

    
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
        self.onPostSurveySuccess = config.onSessionEnded
        self.isAutoStartingWithoutPreSurvey = config.isAutoStartingWithoutPreSurvey
    }
    
    private func handleOnAppear() {
        if let sessionLogId = self.sessionManagementViewModel.sessionLogId {
            print(
                "[ConversationView2] loading initial messages for \(sessionLogId.uuidString)"
            )
            self.chatMessageViewModel.fetchStoredMessages(for: sessionLogId)
            if isAutoStartingWithoutPreSurvey {
                self.chatMessageViewModel.haveSamReachOut()
            }
        } else {
            print(
                "[ConversationView2] no session log id, showing pre survey to start session with slug \(self.slug)"
            )
            self.sessionManagementViewModel.showPreSurvey()
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
    
    var body: some View {
        ConversationWrapperView(
            sessionManagementViewModel: self.sessionManagementViewModel,
            handleOnAppear: self.handleOnAppear,
            onPreSurveySuccess: {
                self.chatMessageViewModel.haveSamReachOut()
            },
            onPostSurveySuccess: self.onPostSurveySuccess
        ) {
            ChatList(
                scrollViewHeight: self.$scrollViewHeight,
                contentHeight: self.$contentHeight,
                scrollOffset: self.$scrollOffset,
                scrollProxy: self.$scrollProxy
            ) {
                if self.chatMessageViewModel.isLoadingExistingMessages {
                    ProgressView().padding(.bottom, scrollViewHeight * 0.4)
                } else {
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
                            onErrorMessageTap: { self.chatMessageViewModel.retry(index: index)},
                            scrollViewHeight: self.scrollViewHeight)
                    }
                }
            }
            .onTapGesture {
                self.isFocused = false
            }
            .overlay(alignment: .bottom) {
                if isShowingScrollToBottomButton {
                    ScrollToBottomButton(onTap: self.handleOnScrollToBottom)
                }
            }
            GrowingTextView(
                isFocused: $isFocused,
                isEndConversationEnabled: self.isEndConversationEnabled,
                customEndConversationLabel: customEndConversationLabel,
                onEndConversation: self.sessionManagementViewModel.handleOnEndConversation,
                onSend: {
                    message in self.chatMessageViewModel.sendMessage(message)
                }
            )
        }
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
        }
    }
}

struct ConversationWrapperView<Content: View>: View {
    let content: Content
    let sessionManagementViewModel: SessionManagementViewModel
    let onPreSurveySuccess: (() -> Void)?
    let onPostSurveySuccess: (() -> Void)?
    let handleOnAppear: () -> Void
    
    init(
        sessionManagementViewModel: SessionManagementViewModel,
        handleOnAppear: @escaping () -> Void,
        onPreSurveySuccess: (() -> Void)?,
        onPostSurveySuccess: (() -> Void)?,
        @ViewBuilder content: () -> Content) {
            self.sessionManagementViewModel = sessionManagementViewModel
            self.handleOnAppear = handleOnAppear
            self.content = content()
            self.onPreSurveySuccess = onPreSurveySuccess
            self.onPostSurveySuccess = onPostSurveySuccess
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
            isLoading: self.sessionManagementViewModel.isSessionStartLoading
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
        sessionLogId: UUID())
    ConversationViewV2(config: config)
}
