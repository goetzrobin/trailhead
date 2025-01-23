//
//  TabBarView.swift
//  trailhead
//
//  Created by Robin Götz on 1/22/25.
//

import SwiftUI

struct PromptSelectionTabBarView: View {
    @Binding var currentTab: String
    @Namespace private var namespace

    let tabBarOptions: [String] = PROMPT_CATEGORIES.map { category in
        return category.name
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(tabBarOptions, id: \.self) { option in
                        PromptSelectionTabBarItemView(
                            currentTab: $currentTab,
                            namespace: namespace,
                            tabBarItemName: option,
                            tab: option
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .onChange(of: currentTab) { _, newTab in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newTab, anchor: .center)
                }
            }
        }
    }
}

#Preview {
    PromptSelectionTabBarView(
        currentTab: Binding(projectedValue: .constant("Identity & Growth")))
}
