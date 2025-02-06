import Observation
import SwiftUI

@Observable final class CheckInViewModel {
    var rotation = 0.0
    var scrollOffset: CGFloat = 0.0
    var isDragging = false
    var dragStartOffset: CGFloat = 0
    private let overAllRateOfChange = 2.0

    func handleScroll(offset: CGFloat) {
        scrollOffset = offset
    }

    // MARK: - Transition Calculations
    func smoothTransition(
        value: CGFloat, delay: CGFloat, rate: CGFloat,
        min minVal: CGFloat = 0, max maxVal: CGFloat = 1
    ) -> CGFloat {
        return min(maxVal, max((value + delay + rate) / rate, minVal))
    }

    var textOpacity: CGFloat {
        smoothTransition(
            value: scrollOffset, delay: 30, rate: 12 * overAllRateOfChange,
            min: 0, max: 1)
    }

    var textOffset: CGFloat {
        50
            * smoothTransition(
                value: scrollOffset, delay: 20, rate: 35 * overAllRateOfChange,
                min: 0, max: 1)
    }

    var circleScaleFactor: CGFloat {
        smoothTransition(
            value: scrollOffset, delay: 0, rate: 400 * overAllRateOfChange,
            min: 0.4, max: 1)
    }

    var circleOpacity: CGFloat {
        smoothTransition(
            value: scrollOffset, delay: 150, rate: 50 * overAllRateOfChange,
            min: 0, max: 1)
    }

    var checkInButtonOpacity: CGFloat {
        smoothTransition(
            value: scrollOffset, delay: 200, rate: 20 * overAllRateOfChange,
            min: 0, max: 1)
    }

    var circlePadding: CGFloat {
        50
            * smoothTransition(
                value: scrollOffset, delay: 0, rate: 40 * overAllRateOfChange,
                min: 0, max: 1)
    }

    var circleWrapperScaleFactor: CGFloat {
        1.4
            * smoothTransition(
                value: scrollOffset, delay: 0, rate: 250 * overAllRateOfChange,
                min: 0.4, max: 1)
    }

}

// MARK: - Main View
struct CheckInView: View {
    @Environment(AppRouter.self) var router: AppRouter
    @State private var viewModel = CheckInViewModel()
    @State private var circleFromTop: CGFloat = 999.0
    @State private var isPresented = false
    var body: some View {
        VStack {
            Text("\(circleFromTop)")
                .padding(.bottom, 20)
            GeometryReader { geometry in
                let circleDiameter = min(geometry.size.width * 0.8, 420)

                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center, spacing: 20) {
                            HeaderView(
                                textOpacity: viewModel.textOpacity,
                                textOffset: viewModel.textOffset,
                                onMeasureTop: { top in
                                    viewModel.handleScroll(offset: top)
                                }
                            )
                            .id("HeaderView")

                            AnimatedCircleView(
                                viewModel: viewModel,
                                circleDiameter: circleDiameter,
                                onCheckInTap: {
                                    self.isPresented = true
                                }
                            )
                            .measureTop(in: .named("ContainerView")) { value in
                                circleFromTop = value
                            }
                            .id(
                                "AnimatedCircleView"
                            )
                            CheckInListView()
                                .id("CheckListView")
                        }
                    }.onScrollPhaseChange({ _, newPhase in
                        if newPhase != .idle { return }
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

                    })
                    .coordinateSpace(name: "ContainerView")
                }
           
            }     .fullScreenCover(isPresented: $isPresented, content: CheckInFlowView.init)

        }
    }
}

// MARK: - View Model

// MARK: - Header View
struct HeaderView: View {
    let textOpacity: CGFloat
    let textOffset: CGFloat
    let onMeasureTop: (CGFloat) -> Void

    var body: some View {
        Text("How are you feeling this evening?")
            .font(.largeTitle)
            .bold()
            .multilineTextAlignment(.center)
            .lineSpacing(0)
            .opacity(textOpacity)
            .padding(.top, textOffset)
            .measureTop(in: .named("ContainerView"), perform: onMeasureTop)
    }
}

// MARK: - Animated Circle View
struct AnimatedCircleView: View {
    let viewModel: CheckInViewModel
    let circleDiameter: CGFloat
    let onCheckInTap: () -> Void

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                AnimatedCircleShape(
                    viewModel: viewModel,
                    circleDiameter: circleDiameter
                )

                CheckInButton(onTap: self.onCheckInTap).opacity(viewModel.checkInButtonOpacity)
            }
            .frame(width: proxy.size.width)
            .padding(.vertical, viewModel.circlePadding)
        }
        .frame(
            height: circleDiameter * viewModel.circleWrapperScaleFactor)
    }
}

// MARK: - Animated Circle Shape
struct AnimatedCircleShape: View {
    let viewModel: CheckInViewModel
    let circleDiameter: CGFloat
    let lineWidth: CGFloat = 30

    var body: some View {
        Circle()
            .strokeBorder(Color.white.opacity(0), lineWidth: self.lineWidth)
            .overlay(
                Circle()
                    .strokeBorder(
                        circleGradient.opacity(0.3),
                        style: createStrokeStyle()
                    )
            )
            .frame(
                width: circleDiameter * viewModel.circleScaleFactor,
                height: circleDiameter * viewModel.circleScaleFactor
            )
            .rotationEffect(Angle(degrees: viewModel.rotation))
            .opacity(viewModel.circleOpacity)
            .onAppear(perform: startRotationAnimation)
    }

    private var circleGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: .gray, location: 0.2),
                .init(color: .gray, location: 0.3),
                .init(color: .clear, location: 1),
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private func createStrokeStyle() -> StrokeStyle {
        StrokeStyle(
            lineWidth: self.lineWidth * viewModel.circleScaleFactor,
            lineCap: .round,
            lineJoin: .round,
            dash: [
                circleDiameter * 2.1 * viewModel.circleScaleFactor,
                circleDiameter * 4,
            ],
            dashPhase: 0
        )
    }

    private func startRotationAnimation() {
        withAnimation(
            .linear(duration: 16)
                .repeatForever(autoreverses: false)
        ) {
            viewModel.rotation = 360.0
        }
    }
}

// MARK: - Check In Button
struct CheckInButton: View {
    let onTap: () -> Void
    var body: some View {
        Button(action: {
            self.onTap()
        }) {
            VStack(alignment: .center, spacing: 5) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                Text("Check in")
                    .foregroundStyle(.white)
            }
        }
    }
}

// MARK: - Check In List View
struct CheckInListView: View {
    var body: some View {
        VStack(spacing: 20) {
            ForEach(1...10, id: \.self) { _ in
                CheckInRow()
            }
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 40)
    }
}

// MARK: - Check In Row
struct CheckInRow: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(MeshGradient(
                    width: 3,
                    height: 3,
                    points: [
                        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                        [0.0, 0.5], [0.5, 0.4], [1.0, 0.5],
                        [0.0, 1.0], [0.8, 1.0], [1.0, 1.0]
                    ],
                    colors: [
                        .black,.black,.green,
                        .black, .black, .green,
                        .black, .black, .green
                    ]
                ))
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                Text("Previous Check-in")
                Spacer()
                Text("2h ago")
                    .foregroundColor(.gray)
            }
        }
        .frame(height: 200)
    }
}

#Preview {
    CheckInView()
        .environment(AppRouter())
}
