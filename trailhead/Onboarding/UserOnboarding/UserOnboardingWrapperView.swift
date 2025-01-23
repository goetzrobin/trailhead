//
//  PhoneSignUpWrapper.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//

import SwiftUI

struct UserOnboardingWrapperView<Content: View>: View {
    private let title: String
    private let subtitle: String
    private let isContinueDisabled: Bool
    private let onBack: () -> Void
    private let onSkip: (() -> Void)?
    private let onContinue: () -> Void
    private let content: () -> Content

    init(
        title: String,
        subtitle: String,
        isContinueDisabled: Bool,
        @ViewBuilder content: @escaping () -> Content,
        onBack: @escaping () -> Void,
        onContinue: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isContinueDisabled = isContinueDisabled
        self.onContinue = onContinue
        self.onBack = onBack
        self.content = content
        self.onSkip = nil
    }

    init(
        title: String,
        subtitle: String,
        isContinueDisabled: Bool,
        @ViewBuilder content: @escaping () -> Content,
        onBack: @escaping () -> Void,
        onContinue: @escaping () -> Void,
        onSkip: (() -> Void)?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isContinueDisabled = isContinueDisabled
        self.onContinue = onContinue
        self.onBack = onBack
        self.content = content
        self.onSkip = onSkip
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .bold()
                .padding(.bottom, 5)
            Text(subtitle)
                .opacity(0.7)
                .padding(.bottom, 20)
            content()
            Spacer()
            Button {
                self.onContinue()
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(.white)
            .foregroundStyle(.black)
            .cornerRadius(100)
            .opacity(self.isContinueDisabled ? 0.6 : 1)
            .disabled(self.isContinueDisabled)
            .animation(.spring(), value: self.isContinueDisabled)
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    self.onBack()
                }) {
                    Label("Back", systemImage: "chevron.left")
                        .font(.system(size: 15))
                        .labelStyle(.iconOnly)
                        .padding(5)
                }
                .buttonStyle(.plain)
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { self.onSkip?() }) {
                    Label("Skip", systemImage: "chevron.right")
                        .font(.system(size: 17))
                        .labelStyle(.titleOnly)
                        .padding(5)
                }
                .opacity(self.onSkip == nil ? 0 : 1)
                .buttonStyle(.plain)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        UserOnboardingWrapperView(title: "What's your name?", subtitle: "This will be the name Sam uses to refer to you.", isContinueDisabled: true) {
            Text("Test")
                .frame(maxWidth: .infinity)
                .inputStyle()
        } onBack: {
            print("back")
        } onContinue: {
            print("continue")
        } onSkip: {
            print("skip")
        }
    }
}
