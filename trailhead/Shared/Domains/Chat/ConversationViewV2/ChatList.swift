//
//  ChatList.swift
//  trailhead
//
//  Created by Robin Götz on 3/9/25.
//
import SwiftUI

struct ChatList<Content: View>: View {
    private var scrollViewHeight: Binding<CGFloat>
    private var contentHeight: Binding<CGFloat>
    private var scrollOffset: Binding<CGFloat>
    private var scrollProxy: Binding<ScrollViewProxy?>

    var content: Content

    init(
        scrollViewHeight: Binding<CGFloat>,
        contentHeight: Binding<CGFloat>,
        scrollOffset: Binding<CGFloat>,
        scrollProxy: Binding<ScrollViewProxy?>,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.scrollViewHeight = scrollViewHeight
        self.contentHeight = contentHeight
        self.scrollOffset = scrollOffset
        self.scrollProxy = scrollProxy
    }
    
    var body: some View {
        _VariadicView
            .Tree(ChatLayout(
                scrollViewHeight: self.scrollViewHeight,
                contentHeight: self.contentHeight,
                scrollOffset: self.scrollOffset,
                scrollProxy: self.scrollProxy
            )) {
                content
            }
    }
}

struct ChatLayout: _VariadicView_MultiViewRoot {
    @Binding var scrollViewHeight: CGFloat
    @Binding var contentHeight: CGFloat
    @Binding var scrollOffset: CGFloat
    @Binding var scrollProxy: ScrollViewProxy?

    func body(children: _VariadicView.Children) -> some View {
        ScrollViewReader { scrollProxy in
            ScrollView([.vertical]) {
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: ScrollOffsetKey.self,
                            value: geometry.frame(in: .named("scrollView")).origin
                        )
                }
                
                
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(children) { child in
                        child
                            .inverted()
                    }
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(
                                key: ContentHeightKey.self,
                                value: geometry.size.height
                            )
                    }
                )
                .padding(.horizontal)
            }
            .coordinateSpace(name: "scrollView")
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollViewHeightKey.self,
                                    value: geometry.frame(in: .global).height)
                }
            }
            .onPreferenceChange(ScrollViewHeightKey.self) { height in
                self.scrollViewHeight = height
                print("ScrollView height: \(height)")
            }
            .onPreferenceChange(ContentHeightKey.self) { height in
                self.contentHeight = height
            }
            .onPreferenceChange(ScrollOffsetKey.self) { offset in
                self.scrollOffset = offset.y
            }
            .inverted()
            .onAppear {
                self.scrollProxy = scrollProxy
            }
        }
    }
}

struct ScrollViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
