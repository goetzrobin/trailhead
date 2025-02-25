//
//  CheckInAnimatedCircleView.swift
//  trailhead
//
//  Created by Robin Götz on 2/10/25.
//
import Foundation
import SwiftUI

struct CheckInAnimatedCircleView: View {
    let viewModel: CheckInAnimationViewModel
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
    let viewModel: CheckInAnimationViewModel
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
                Text("Check in")
            }
        }.buttonStyle(.plain)
    }
}

#Preview {
    CheckInAnimatedCircleView(viewModel: CheckInAnimationViewModel(), circleDiameter: 300, onCheckInTap: {
        print("Tapped")
    })
}
