//
//  Welcome.swift
//  trailhead
//
//  Created by Robin Götz on 1/13/25.
//

import SwiftUI

struct WelcomeView: View {
    @State var isButtonVisible = false
    @State var isHeadingVisible = false
    @State var isSubHeadingVisible = false

    let onTap: () -> Void

    init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }

    var body: some View {
        ZStack {
            Image("welcome-basketball")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0),
                    Color.black.opacity(0.4),
                    Color.black.opacity(0.7),
                    Color.black.opacity(1),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()
                VStack(spacing: 5) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Someone in your corner.")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        Text("Always.")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                    }
                    .fadeInSlideUp(isVisible: self.isHeadingVisible)

                    Text(
                        "Personal guidance for life's biggest moments and daily decisions."
                    )
                    .fadeInSlideUp(isVisible: self.isSubHeadingVisible)

                    .foregroundColor(.white)
                }
                Button {
                    self.onTap()
                } label: {
                    Text("Get started")
                        .frame(maxWidth: .infinity)

                }
                .padding()
                .background(.white)
                .foregroundStyle(.black)
                .cornerRadius(100)
                .padding()
                .fadeInSlideUp(isVisible: self.isButtonVisible)

            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.isHeadingVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.isSubHeadingVisible = true
            }
            // Short delay before button animation starts
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.isButtonVisible = true
            }
        }
    }

}

#Preview {
    WelcomeView {
        print("Hello")
    }
}
