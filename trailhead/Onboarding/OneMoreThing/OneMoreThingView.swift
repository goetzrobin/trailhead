//
//  OneMoreThingView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct OneMoreThingView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let isSubmittingOnboardingLetter: Bool
    let onStartJourney: (_: String) -> Void
    
    @State var animationPhase = 0
    @State var text: String = ""
    
    var body: some View {
        VStack {
            if animationPhase == 0 {
                VStack {
                    Text("One more thing")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                    Text(
                        "Introduce yourself to Sam! Answer each question briefly, like a quick interview. Your responses will help Sam get to know you!"
                    )
                    .opacity(0.7)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            LetterView(text: $text, animationPhase: $animationPhase)
                .padding(.bottom,animationPhase == 0 ? 80 : 0)
            if animationPhase == 0 {
                Button(action:
                        {
                    self.onStartJourney(text)
                }, label: {
                    HStack {
                        if self.isSubmittingOnboardingLetter {
                            ProgressView().tint(self.colorScheme == .light ? .white : .black)
                        } else {
                            Text("Start journey")
                        }
                    }.frame(maxWidth: .infinity)
                })
                .buttonStyle(.jPrimary)
                .disabled(self.text.isEmpty || self.isSubmittingOnboardingLetter)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    OneMoreThingView(isSubmittingOnboardingLetter: true){ text in
        print("start over \(text)")
    }
}
