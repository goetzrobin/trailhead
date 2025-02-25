//
//  Welcome.swift
//  trailhead
//
//  Created by Robin Götz on 1/13/25.
//

import SwiftUI

struct WelcomeView: View {
    let onSignInTap: (() -> Void)?
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
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
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
                    }
                    
                    Button {
                        self.onTap()
                    } label: {
                        Text("Get started")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.jWhite)
                    .padding(.bottom, 20)
                    Button {
                        self.onSignInTap?()
                    } label: {
                        Text("I already have an account")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom)
                }
            }.padding(.horizontal)
        }
    }
}

#Preview {
    WelcomeView {
        print("Welcome")
    } onTap: {
        print("Hello")
    }
}
