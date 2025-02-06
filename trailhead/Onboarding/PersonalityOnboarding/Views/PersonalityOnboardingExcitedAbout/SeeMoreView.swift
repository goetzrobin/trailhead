//
//  SeeMoreView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct SeeMoreView<Content: View>: View {
    @State private var isShowingMore = false
    @State private var subviewHeight: CGFloat = 0
    let content: () -> Content
    let cutoffHeight: CGFloat

    init(
        cutoffHeight: CGFloat = 255,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.cutoffHeight = cutoffHeight
    }

    var body: some View {
        VStack(spacing: 0) {
            content()
                .padding(.horizontal)
                .padding(.top)
                .background(
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: ViewHeightKey.self,
                            value: geometry.size.height
                        )
                    }
                )
                .onPreferenceChange(ViewHeightKey.self) { subviewHeight = $0 }
                .frame(
                    height: isShowingMore ? subviewHeight : cutoffHeight,
                    alignment: .top
                )
                .clipped()
                .animation(.spring, value: isShowingMore)  // Smooth expansion/collapse

            HStack {
                Button(
                    action: {
                        withAnimation(.spring) {
                            isShowingMore.toggle()
                        }
                    },
                    label: {
                        Text(!self.isShowingMore ? "See more" : "See less")
                            .font(.headline)
                    }
                )
                .buttonStyle(.plain)
                .padding(.vertical, 18)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .padding(.bottom, 24)  // Optional: Additional padding for better layout
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = value + nextValue()
    }
}
