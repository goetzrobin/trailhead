//
//  PhoneSignUpWrapper.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//

import SwiftUI

struct PhoneSignUpWrapperView<Content: View>: View {
    let title: String
    let onExit: () -> Void
    let content: () -> Content
    let onBack: (() -> Void)?

    init(
        title: String,
        @ViewBuilder content: @escaping () -> Content,
        onExit: @escaping () -> Void
    ) {
        self.title = title
        self.onExit = onExit
        self.content = content
        self.onBack = nil
    }

    init(
        title: String,
        @ViewBuilder content: @escaping () -> Content,
        onExit: @escaping () -> Void,
        onBack: (() -> Void)?
    ) {
        self.title = title
        self.onExit = onExit
        self.content = content
        self.onBack = onBack
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .bold()
            content()
        }
        .padding()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    self.onBack?()
                }) {
                    Label("Back", systemImage: "chevron.left")
                        .navigationLabelStyle()
                }
                .opacity(self.onBack == nil ? 0 : 1)
                .disabled(self.onBack == nil)
                .buttonStyle(.plain)
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: self.onExit) {
                    Label("Exit", systemImage: "xmark")
                        .navigationLabelStyle()
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PhoneSignUpWrapperView(title: "Nobody likes reading their emails...") {
            PhoneSignUpEnterNumberView()
                .environment(PhoneSignUpStore())
        } onExit: {
            print("closing time")
        } onBack: {
            print("back like we never left")
        }
    }
}
