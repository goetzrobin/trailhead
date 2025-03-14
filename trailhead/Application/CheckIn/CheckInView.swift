import Observation
import SwiftUI

// MARK: - Main View
struct CheckInView: View {
    @Environment(AppRouter.self) var router: AppRouter
    @Environment(CheckInAPIClient.self) var checkInApiClient: CheckInAPIClient
    @Environment(SessionAPIClient.self) var sessionApiClient: SessionAPIClient
    @Environment(AuthStore.self) var authStore: AuthStore
    @State private var viewModel = CheckInAnimationViewModel()
    @State private var circleFromTop: CGFloat = 999.0
    @State private var isDoingCheckIn = false

    @State private var isContinuingCheckInForSessionLog: SessionLog? = nil

    private var checkIns: [SessionLog] {
        self.checkInApiClient.fetchCheckInLogsStatus.data ?? []
    }
    
    private var shouldAnimate: Bool {
        self.checkIns.count > 2
    }

    func handleScrollPhaseChange(newPhase: ScrollPhase, proxy: ScrollViewProxy)
    {
        if newPhase != .idle { return }
        if !self.shouldAnimate { return }
        if self.circleFromTop > 100 {
            withAnimation(.spring) {
                proxy.scrollTo("HeaderView", anchor: .top)
            }
        } else if self.circleFromTop < -120
                    && self.circleFromTop > -175
        {
            withAnimation(.spring) {
                proxy.scrollTo("CheckListView", anchor: .top)
            }
        } else if self.circleFromTop < 100
            && self.circleFromTop > -35
        {
            withAnimation(.spring) {
                proxy.scrollTo(
                    "AnimatedCircleView", anchor: .top)
            }
        }
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                let circleDiameter = min(geometry.size.width * 0.8, 420)

                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center, spacing: 20) {
                            CheckInHeaderView(
                                textOpacity: viewModel.textOpacity,
                                textOffset: viewModel.textOffset,
                                onMeasureTop: { top in
                                    viewModel.handleScroll(offset: top)
                                }
                            )
                            .id("HeaderView")

                            CheckInAnimatedCircleView(
                                viewModel: viewModel,
                                circleDiameter: circleDiameter,
                                onCheckInTap: {
                                    self.isDoingCheckIn = true
                                }
                            )
                            .measureTop(
                                in: CoordinateSpace.named("ContainerView")
                            ) { value in
                                circleFromTop = value
                            }
                            .id(
                                "AnimatedCircleView"
                            )
                            
                            CheckInListView(checkIns: self.checkIns) {
                                sessionLog in self.isContinuingCheckInForSessionLog = sessionLog
                            }
                                .id("CheckListView")
                        }
                    }.onScrollPhaseChange({ _, newPhase in
                        handleScrollPhaseChange(
                            newPhase: newPhase, proxy: proxy)
                    })
                    .coordinateSpace(name: "ContainerView")
                }

            }
            .fullScreenCover(
                isPresented: $isDoingCheckIn, content: CheckInFlowView.init)
            .fullScreenCover(
                isPresented: Binding(get: {isContinuingCheckInForSessionLog != nil}, set: {newValue in
                    if !newValue { self.isContinuingCheckInForSessionLog = nil}
                })) {
                    if let userId = authStore.userId, let isContinuingCheckInForSessionLog = self.isContinuingCheckInForSessionLog {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action:   {withAnimation {
                                    self.isContinuingCheckInForSessionLog = nil
                                }}, label: {
                                    Label("Come back later", systemImage: "xmark").labelStyle(.iconOnly)
                                })
                            }
                            .padding()
                            ConversationViewV2(config: ConversationConfig(
                                sessionApiClient: sessionApiClient,
                                authProvider: authStore,
                                slug: "unguided-open-v0",
                                userId: userId,
                                sessionLogId: isContinuingCheckInForSessionLog.id,
                                sessionLogStatus: isContinuingCheckInForSessionLog.status,
                                maxSteps: nil,
                                customEndConversationLabel: "End Check-In",
                                onSessionEnded: {
                                    self.checkInApiClient.fetchCheckInLogs(for: userId)
                                },
                                onNotNow: {
                                    withAnimation {
                                        self.isContinuingCheckInForSessionLog = nil
                                    }
                                }
                            ))
                        }
                    }
                }
            .onAppear {
                self.viewModel.shouldAnimate = self.shouldAnimate
            }
            .onChange(of: shouldAnimate) { _, newValue in
                self.viewModel.shouldAnimate = newValue
            }
        }
    }
}

#Preview {
    CheckInView()
        .environment(AppRouter())
        .environment(CheckInAPIClient(authProvider: AuthStore()))
}
