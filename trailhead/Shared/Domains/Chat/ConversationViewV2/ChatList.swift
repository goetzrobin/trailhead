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
            // I dont know why 5 here and 15 below look alright?
                }.frame(height: 5)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(children) { $0.inverted()}
                }
                .padding(.horizontal)

                .background {
                    GeometryReader { geometry in
                        Color.clear
                            .preference(
                                key: ContentHeightKey.self,
                                value: geometry.size.height
                            )
                    }
                }
                // like this is a hack but idk what
                .offset(y: -15)
            }
            .coordinateSpace(name: "scrollView")
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollViewHeightKey.self,
                                    value: geometry.frame(in: .global).height)
                }
            }
            .onPreferenceChange(ScrollViewHeightKey.self) { self.scrollViewHeight = $0 }
            .onPreferenceChange(ContentHeightKey.self) { self.contentHeight = $0 }
            .onPreferenceChange(ScrollOffsetKey.self) { self.scrollOffset = $0.y }
            .onAppear { self.scrollProxy = scrollProxy }
            
        }.inverted()
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
