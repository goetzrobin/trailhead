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
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(AppRouter.self) var router: AppRouter
    @Environment(AuthStore.self) var authStore: AuthStore
    @Environment(SessionAPIClient.self) var sessionApiClient: SessionAPIClient
    @Environment(CheckInAPIClient.self) var checkInApiClient: CheckInAPIClient

    @State var status: CheckInStatus = .pickingTopic
    var body: some View {
        VStack {
            if status == .pickingTopic {
                VStack {
                CloseHeader {
                    self.dismiss()
                }
                    ScrollView(.vertical, showsIndicators: false) {
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
                        
                        Text("Why check-ins matter:")
                            .font(.subheadline)
                            .bold()
                            .padding(.top, 20)
                        
                        Text("Regular conversations with Sam help you process your emotions in a safe space. By talking through what you're feeling, you develop clarity and perspective. Sam helps you understand your emotional patterns, build resilience, and discover strategies that work uniquely for you.")
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                    }
                }.padding(.horizontal)
            }
            if status == .inConversation, let userId = authStore.userId {
                VStack {
                    CloseHeader {
                        self.dismiss()
                        self.checkInApiClient.fetchCheckInLogs(for: userId)
                    }
                    .padding(.horizontal)
                    ConversationViewV2(config: ConversationConfig(
                        sessionApiClient: sessionApiClient,
                        authProvider: authStore,
                        slug: "unguided-open-v0",
                        userId: userId,
                        sessionLogId: nil,
                        maxSteps: nil,
                        onSessionEnded: {
                            self.checkInApiClient.fetchCheckInLogs(for: userId)
                            self.dismiss()
                        },
                        onNotNow: {
                            withAnimation {
                                self.status = .pickingTopic
                            }
                        }
                    ))
                }
            }
        }
        .frame(maxHeight: .infinity)
        .background {
            BackgroundBlurView(colorScheme: colorScheme)
                .edgesIgnoringSafeArea(.all)
        }
    }
}


struct BackgroundBlurView: UIViewRepresentable {
    let colorScheme: ColorScheme
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(
            effect: UIBlurEffect(
                style: self.colorScheme == .dark ? .dark : .light
            )
        )
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    @Previewable @State var auth = AuthStore()
    CheckInFlowView()
        .environment(auth)
        .environment(SessionAPIClient(authProvider: auth))
        .environment(CheckInAPIClient(authProvider: auth))
        .environment(AppRouter())
        .background(.background)
}
