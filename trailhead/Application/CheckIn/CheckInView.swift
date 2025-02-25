import Observation
import SwiftUI

// MARK: - Main View
struct CheckInView: View {
    @Environment(AppRouter.self) var router: AppRouter
    @State private var viewModel = CheckInAnimationViewModel()
    @State private var circleFromTop: CGFloat = 999.0
    @State private var isDoingCheckIn = false
    
    @State private var checkIns: [CheckIn] = []
    
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
                            
                            CheckInListView(checkIns: self.checkIns)
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
}
