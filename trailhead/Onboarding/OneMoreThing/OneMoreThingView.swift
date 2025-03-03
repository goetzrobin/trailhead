//
//  OneMoreThingView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct OneMoreThingView: View {
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
                    Text("Introduce yourself to Sam! Answer each question briefly, like a quick interview. Your responses will help Sam get to know you!")
                        .opacity(0.7)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
            }
            LetterView(text: $text, animationPhase: $animationPhase)
                .padding(.bottom,animationPhase == 0 ? 80 : 0)
            if animationPhase == 0 {
                Button("Start journey")
                {
                    self.onStartJourney(text)
                }
                .buttonStyle(.jPrimary)
                .disabled(self.text.isEmpty)
            }
        }
    }
}

#Preview {
    OneMoreThingView{ text in
        print("start over \(text)")
    }
}
