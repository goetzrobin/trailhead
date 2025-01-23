//
//  PersonalityOnboardingIntroView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct PersonalityOnboardingIntroView: View {
    private let onContinue: () -> Void

    init(onContinue: @escaping () -> Void) {
        self.onContinue = onContinue
    }
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("✌️")
                    .font(.system(size: 60))
                    .padding(.bottom, -10)
                Text("Let's make this about you!")
                    .font(.largeTitle)
                    .bold()
                Text(
                    "Small details make big differences. They build your story. They help Sam give advice that’s truly yours."
                )
                .opacity(0.7)
            }
            .padding(.horizontal)
            .padding(.top, -100)
            Spacer()
            Button(action: {
                self.onContinue()
            }) {
                Text("Continue")
            }.padding()
        }
    }
}

#Preview {
    PersonalityOnboardingIntroView {
        print("continue")
    }
}
