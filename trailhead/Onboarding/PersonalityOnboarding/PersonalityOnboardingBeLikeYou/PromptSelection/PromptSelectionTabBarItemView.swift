//
//  PromptSelectionTabBarItemView.swift
//  trailhead
//
//  Created by Robin Götz on 1/22/25.
//

import SwiftUI

struct PromptSelectionTabBarItemView: View {
    @Binding var currentTab: String
    let namespace: Namespace.ID
    let tabBarItemName: String
    let tab: String

    var body: some View {
        Button(action: {
            currentTab = tab
            print("Selected tab: \(currentTab)")  // Debug
        }) {
            VStack {
                Text(tabBarItemName)
                    .foregroundColor(currentTab == tab ? .white : .gray)
                    .fontWeight(currentTab == tab ? .semibold : .regular)

                if currentTab == tab {
                    Rectangle()
                        .fill(.foreground)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace)
                } else {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 2)
                }
            }
        }
        .animation(.spring(), value: currentTab)  // Smooth animation for changes
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    return PromptSelectionTabBarItemView(
        currentTab: .constant("Test"),
        namespace: namespace,
        tabBarItemName: "Hello",
        tab: "World"
    )
}
