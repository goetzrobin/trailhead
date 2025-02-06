//
//  TabBarView.swift
//  trailhead
//
//  Created by Robin Götz on 1/22/25.
//

import SwiftUI

struct PromptSelectionTabBarView: View {
    @Binding var currentTab: String
    let responses: [PromptOptionAndResponse?]
    @Namespace private var namespace

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(PROMPT_CATEGORIES, id: \.name) { category in
                        PromptSelectionTabBarItemView(
                            currentTab: $currentTab,
                            namespace: namespace,
                            tabBarItemName: category.name,
                            tab: category.name,
                            checked: isCategoryChecked(category: category)
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 18)
            }
            .onChange(of: currentTab) { _, newTab in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newTab, anchor: .center)
                }
            }
        }
    }

    private func isCategoryChecked(category: PromptCategory) -> Bool {
        // Check if any response exists in this category's options
        return responses.contains { response in
            guard let responseOption = response?.option else { return false }
            return category.options.contains(responseOption)
        }
    }
}

#Preview {
    PromptSelectionTabBarView(
        currentTab: Binding(projectedValue: .constant("Identity & Growth")),
        responses: []
    )
}
