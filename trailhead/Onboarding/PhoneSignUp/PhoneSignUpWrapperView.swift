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

    init(
        title: String,
        @ViewBuilder content: @escaping () -> Content,
        onExit: @escaping () -> Void
    ) {
        self.title = title
        self.onExit = onExit
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: self.onExit) {
                    Label("Exit", systemImage: "xmark")
                        .font(.system(size: 25))
                        .labelStyle(.iconOnly)
                        .padding(5)
                }
            }
            .foregroundStyle(.foreground)
            .buttonStyle(.borderless)
            Text(title)
                .font(.largeTitle)
                .bold()
            content()
        }
        .padding()
    }
}

#Preview {
    PhoneSignUpWrapperView(title: "Nobody likes reading their emails...") {
        PhoneSignUpEnterNumberView()
        .environment(PhoneSignUpStore())
    } onExit: {
        print("closing time")
    }
}
