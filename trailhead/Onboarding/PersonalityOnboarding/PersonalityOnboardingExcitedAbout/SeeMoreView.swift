//
//  SeeMoreView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct SeeMoreView<Content: View>: View {
    @State var isShowingMore = false
    @State var subviewHeight: CGFloat = 0
    let content: () -> Content
    let cutoffHeight: CGFloat

    init(
        cutoffHeight: CGFloat = 265,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.cutoffHeight = cutoffHeight
    }

    var body: some View {
        VStack {
            content()
                .background(
                    GeometryReader {
                        Color.clear.preference(
                            key: ViewHeightKey.self,
                            value: $0.frame(in: .local).size.height)
                    }
                )
                .onPreferenceChange(ViewHeightKey.self) { subviewHeight = $0 }
                .frame(
                    height: self.isShowingMore ? subviewHeight : self.cutoffHeight,
                    alignment: .top
                )
                .padding()
                .clipped()
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .bottom))
            Button("See \(self.isShowingMore ? "less" : "more")") {
                withAnimation(.spring) {
                    self.isShowingMore.toggle()
                }
            }.buttonStyle(.plain)
                .padding(.bottom, 40)
        }
        .padding(.bottom)
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
