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
    
    var checked: Bool = false
    var fontSize = 13.0
    var horizontalPadding = 18.0
    var verticalPadding = 12.0
    var strokeWidth = 1.7

    @State private var scale: CGFloat = 0
    @State private var checkWidth: CGFloat = 0

    func updateAnimationState(isChecked: Bool) {
        if isChecked {
            // Checked sequence: width first, then scale in
            withAnimation(.spring(duration: 0.4, bounce: 0.5)) {
                checkWidth = 20
            }
            withAnimation(
                .interpolatingSpring(duration: 0.4, bounce: 0.4).delay(0.2)
            ) {
                scale = 1
            }
        } else {
            // Unchecked sequence: scale out first, then width
            withAnimation(.spring(duration: 0.2)) {
                scale = 0
            }
            withAnimation(.spring(duration: 0.3, bounce: 0.2).delay(0.15)) {
                checkWidth = 0
            }
        }
    }

    var body: some View {
        Button(action: {
            currentTab = tab
        }) {
            ZStack {
                // Capsule background for selected tab
                if currentTab == tab {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.jAccent)
                        .matchedGeometryEffect(id: "capsule", in: namespace)
                }

                // Text with conditional styling
                HStack(spacing: 0) {
                    Image(systemName: "checkmark")
                        .font(.system(size: self.fontSize * 1.2))
                        .foregroundStyle(currentTab == tab ? .black : .jAccent)
                        .padding(.trailing, 12)
                        .padding(.leading, 4)
                        .scaleEffect(scale)
                        .frame(width: checkWidth)
                    Text(tabBarItemName)
                        .font(.system(size: self.fontSize))
                        .foregroundColor(currentTab == tab ? .black : .jAccent)
                }
                .padding(.horizontal, self.horizontalPadding)
                .padding(.vertical, self.verticalPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .inset(by: self.strokeWidth)
                        .stroke(
                            currentTab == tab ? Color.clear : Color.jAccent,
                            lineWidth: self.strokeWidth)
                )

            }
        }
        .fixedSize(horizontal: true, vertical: true)
        .animation(
            .spring(response: 0.3, dampingFraction: 0.7), value: currentTab
        )
        .onAppear { updateAnimationState(isChecked: checked) }
        .onChange(of: checked) { _, newValue in
            updateAnimationState(isChecked: newValue)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var isChecked = false
    VStack {
        PromptSelectionTabBarItemView(
            currentTab: .constant("World"),
            namespace: namespace,
            tabBarItemName: "Hello",
            tab: "World",
            checked: isChecked
        )
        PromptSelectionTabBarItemView(
            currentTab: .constant("Black"),
            namespace: namespace,
            tabBarItemName: "Hello",
            tab: "World",
            checked: true
        )
        Button("check") {
            isChecked.toggle()
        }
    }
}
