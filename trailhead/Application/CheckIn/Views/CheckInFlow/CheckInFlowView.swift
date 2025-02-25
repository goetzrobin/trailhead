//
//  CheckInFlowView.swift
//  trailhead
//
//  Created by Robin Götz on 2/5/25.
//

import SwiftUI

enum CheckInStatus {
    case pickingTopic
    case inConversation
    case conversationCompleted
}

struct CheckInFlowView: View {
    @Environment(AppRouter.self) var router: AppRouter
    @Environment(AuthStore.self) var authStore: AuthStore
    @Environment(SessionAPIClient.self) var sessionApiClient: SessionAPIClient

    @State var status: CheckInStatus = .pickingTopic
    var body: some View {
        ZStack {
            VStack {
                CloseHeader()
                if status == .pickingTopic {
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Let's just check in")
                                .font(.title)
                                .bold()
                            Text("Chat with Sam about whatever is on your mind")
                                .padding(.bottom, 20)
                            Button(
                                action: {
                                    withAnimation {
                                        self.status = .inConversation
                                    }
                                },
                                label: {
                                    Text("Begin")
                                        .frame(maxWidth: .infinity)
                                }
                            ).buttonStyle(.jSecondary)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Material.ultraThinMaterial)
                        )

                        Text("Or begin with a topic")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 30)

                        TopicsGridView(onTopicSelected: { topic in
                            print("Selected topic: \(topic.slug)")
                            self.status = .inConversation
                        })

                    }
                }
                if status == .inConversation {
                    ConversationView(
                        sessionApiClient: sessionApiClient,
                        authProvider: authStore,
                        slug: "test-v0",
                        userId: UUID(),
                        sessionLogId: UUID(),
                        maxSteps: 0
                    )
                }
                Spacer()
            }
            .padding()
            .safeAreaPadding(.top, 40)
        }
        .frame(maxHeight: .infinity)
        .background(BackgroundBlurView())
        .edgesIgnoringSafeArea(.all)
    }
}

struct CloseHeader: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        HStack {
            Spacer()
            Button {
                self.dismiss()
            } label: {
                Label("Close", systemImage: "xmark")
                    .labelStyle(.iconOnly)
                    .padding()
            }
        }
    }
}

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    CheckInFlowView().environment(AppRouter())
}
