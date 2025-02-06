//
//  Welcome.swift
//  trailhead
//
//  Created by Robin Götz on 1/13/25.
//

import SwiftUI

struct WelcomeView: View {
    let onTap: () -> Void

    var body: some View {
        ZStack {
            Image("welcome-basketball")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.4),
                    Color.black.opacity(0.7),
                    Color.black.opacity(1),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                VStack(spacing: 0) {
                    Image("logo-light")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 45)
                        .padding(.top, 3)
                    Text("journai")
                        .font(.system(size: 45))
                        .foregroundColor(.white)
                        .bold()
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    VStack(alignment: .leading, spacing: -4) {
                        Text("Someone in your corner.")
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                        Text("Always.")
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                    }
                    Text(
                        "Personal guidance for life's biggest moments and daily decisions."
                    )
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: 340)
                }
                Button {
                    self.onTap()
                } label: {
                    Text("Get started")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.jWhite)
                .frame(maxWidth: 340)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    WelcomeView {
        print("Hello")
    }
}
