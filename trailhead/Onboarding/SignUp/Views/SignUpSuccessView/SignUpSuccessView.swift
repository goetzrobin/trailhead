//
//  PhoneSignUpSuccessView.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import SwiftUI

struct SignUpSuccessView: View {
    let onContinue: () -> Void
    init(onContinue: @escaping () -> Void) {
        self.onContinue = onContinue
    }
    @State private var drawingPercentage: CGFloat = 0

    var body: some View {
        ZStack {
            HandDrawnLine(percentage: drawingPercentage)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(
                        lineWidth: 170,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .onAppear {
                    withAnimation(.spring(duration: 3, bounce: 0.4)) {
                        drawingPercentage = 1.0
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 20) {
                Text("Welcome to journai!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 50, weight: .bold, design: .default))
                    .signUpSuccessDelayedAppearance(delay: 0.7)
                Text("We can't wait to get started!")
                    .multilineTextAlignment(.center)
                    .bold()
                    .signUpSuccessDelayedAppearance(delay: 1.4)
            }.padding(.top, -80)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                self.onContinue()
            }
        }

    }

}

#Preview {
    SignUpSuccessView {
        print("continue")
    }
}
