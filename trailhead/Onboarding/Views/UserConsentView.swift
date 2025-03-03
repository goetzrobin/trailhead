//
//  UserConsent.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//

import SwiftUI

struct UserConsentView: View {
    @Environment(\.colorScheme) private var colorScheme
    let onTap: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 5) {
                    Image(colorScheme == .light ? "logo-dark" : "logo-light")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 45)
                    Text("Terms & Privacy")
                        .font(.title)
                        .bold()
                        .padding(.bottom)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("You decide what to share")
                        .font(.title2)
                    Text("Your conversations are stored securely on our servers. We never sell your data and only use it to improve journai or validate our efficacy with our research partners with your permission. For app improvements, we collect basic anonymous usage data.")
                        .foregroundStyle(.secondary)
                        .padding(.bottom,40)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("This app isn't the same thing as therapy")
                        .font(.title2)
                    Text("The advice in this app is intended for general information purposes only. Please don’t rely upon this information in the same way you would a medical professional. While Journai personalizes guidance based on your circumstances, it's not a substitute for professional medical advice tailored to your individual needs.")
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 40)
                }
                VStack(alignment: .leading) {
                    Text("By continuing you agree to our [Terms of Service](https://myjournai.vercel.app/terms) and [Privacy Policy.](https://myjournai.vercel.app/privacy-policy)")
                        .padding(.bottom, 80)
                    Button {
                        self.onTap()
                    } label: {
                        Text("I accept")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.jPrimary)
                    .padding(.bottom)
                }
            }
            .padding()
        }
    }
}

#Preview {
    UserConsentView{
        print("Hello there")
    }
}
