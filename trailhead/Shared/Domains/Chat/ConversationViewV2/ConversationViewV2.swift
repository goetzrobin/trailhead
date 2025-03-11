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

    // State
    @State private var scrollViewHeight: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    @FocusState private var isFocused: Bool
    @State private var reply: String = ""
    @State private var isEndConversationEnabled = true

    
    private var isShowingScrollToBottomButton: Bool {
        scrollOffset < -20.0 && !self.chatMessageViewModel.isLoadingExistingMessages &&
        self.chatMessageViewModel.messages.count > 0
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
            sessionLogStatus: config.sessionLogStatus,
            onSessionEnded: config.onSessionEnded
        )
        self.chatMessageViewModel = ChatMessageViewModel(
            messageAPIClient: ChatMessageAPIClient(
                authProvider: config.authProvider
            ),
            sessionLogId: config.sessionLogId
        )
    }
    
    private func handleOnAppear() {
        if let sessionLogId = self.sessionManagementViewModel.sessionLogId {
            print(
                "[ConversationView2] loading initial messages for \(sessionLogId.uuidString)"
            )
            self.chatMessageViewModel.fetchStoredMessages()
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
            handleOnAppear: self.handleOnAppear
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
                    
                    // then we always display the currently streamed message
                    //
                    //                StreamingMessageWithPlaceholderView(
                    //                    isStarting: self.isStarting,
                    //                    scrollViewHeight: self.scrollViewHeight
                    //                )
                    //
                    ForEach(self.chatMessageViewModel.messages) { message in
                        Text("\(message)")
                    }
//                    ForEach(
//                        self.chatMessageViewModel.messages,
//                        id: \.id
//                    ) { message in
//                        HStack {
//                            if message.sender == .ai {
//                                MentorMessageView(
//                                    message: message.content,
//                                    isComplete: message.state == .complete
//                                )
//                            } else {
//                                UserMessageView(message: message)
//                            }
//                        }
//                    }
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
                onEndConversation: self.sessionManagementViewModel.handleOnEndConversation,
                onSend: {
                    message in self.chatMessageViewModel.sendMessage(message)
                }
            )
        }
    }
}

struct ConversationWrapperView<Content: View>: View {
    let content: Content
    let sessionManagementViewModel: SessionManagementViewModel
    let handleOnAppear: () -> Void
    
    init(sessionManagementViewModel: SessionManagementViewModel,
         handleOnAppear: @escaping () -> Void,
         @ViewBuilder content: () -> Content) {
        self.sessionManagementViewModel = sessionManagementViewModel
        self.handleOnAppear = handleOnAppear
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
        ) {            SurveyView(
            variant: .pre,
            isLoading: self.sessionManagementViewModel.isSessionStartLoading
        ) { feeling, anxiety, motivation in
            self.sessionManagementViewModel.handlePreSurveySubmission(
                feeling: feeling,
                anxiety: anxiety,
                motivation: motivation
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
                    motivation: motivation
                )
            }
            .surveySheet(isDismissable: true)
        }
        .onAppear(perform: self.handleOnAppear)
    }
}


struct StreamingMessageWithPlaceholderView: View {
    let mentorMessage: String
    let userMessage: String
    let isWaitingForStreamToStart: Bool
    let isStreamCompleted: Bool
    let scrollViewHeight: CGFloat
    var body: some View {
        VStack {
            UserMessageView(message: userMessage)
            if isWaitingForStreamToStart {
                HStack {
                    PulsingCircle()
                    Spacer()
                }
            } else {
                MentorMessageView(
                    message: self.mentorMessage,
                    isComplete: self.isStreamCompleted
                )
            }
        }.frame(maxWidth: .infinity,
                idealHeight: !self.isStreamCompleted ? max(0,scrollViewHeight - 50) : nil,
                maxHeight: scrollViewHeight,
                alignment: .topTrailing
        )
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
