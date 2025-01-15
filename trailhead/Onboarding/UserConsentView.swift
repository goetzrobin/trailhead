//
//  UserConsent.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//

import SwiftUI

struct UserConsentView: View {
    @State var isHeadingVisible = false
    @State var isYouDecideVisible = false
    @State var isNotTherapyVisible = false
    @State var isLinksAndButtonVisible = false

    
    let onTap: () -> Void
    init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 5) {
                    Image("journai-j")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                    Text("Terms & Privacy")
                        .font(.title)
                        .padding(.bottom)
                }
                .fadeInSlideUp(isVisible: self.isHeadingVisible)
                VStack(alignment: .leading, spacing: 5) {
                    Text("You decide what to share")
                        .font(.title2)
                    Text("Your conversations are stored securely on our servers. We never sell your data and only use it to improve journai or validate our efficacy with our research partners with your permission. For app improvements, we collect basic anonymous usage data.")
                        .foregroundStyle(.secondary)
                        .padding(.bottom,40)
                }
                .fadeInSlideUp(isVisible: self.isYouDecideVisible)
                VStack(alignment: .leading, spacing: 5) {
                    Text("This app isn't the same thing as therapy")
                        .font(.title2)
                    Text("The advice in this app is intended for general information purposes only. Please don’t rely upon this information in the same way you would a medical professional. While Journai personalizes guidance based on your circumstances, it's not a substitute for professional medical advice tailored to your individual needs.")
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 40)
                }
                .fadeInSlideUp(isVisible: self.isNotTherapyVisible)
                VStack(alignment: .leading) {
                    Text("By continuing you agree to our [Terms of Service](https://thejournai.com/terms-of-service) and [Privacy Policy.](https://thejournai.com/privacy-policy)")
                        .padding(.bottom, 80)
                    Button {
                        self.onTap()
                    } label: {
                        Text("Get started")
                            .frame(maxWidth: .infinity)
                        
                    }
                    .padding()
                    .foregroundStyle(.background)
                    .background(.foreground)
                    .cornerRadius(100)
                }
                .fadeInSlideUp(isVisible: self.isLinksAndButtonVisible)
                
            }
            .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.isHeadingVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.isYouDecideVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.isNotTherapyVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                self.isLinksAndButtonVisible = true
            }
        }
    }
}

#Preview {
    UserConsentView{
        print("Hello there")
    }
}
