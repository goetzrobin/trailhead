//
//  PromptSelectionView.swift
//  trailhead
//
//  Created by Robin Götz on 1/22/25.
//

import SwiftUI

struct PromptSelectionView: View {
    @State private var showingAll = false
    @State private var currentTab: String = PROMPT_CATEGORIES[0].id

    let onSelectOption: (_ option: PromptOption) -> Void
    let onClose: () -> Void

    let allPromptOptions = PROMPT_CATEGORIES.flatMap { category in
        return category.options
    }

    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentTab) {
                ForEach(PROMPT_CATEGORIES, id: \.id) { category in
                    List(category.options) {
                        option in
                        PromptOptionListItemView(option: option) {
                            self.onSelectOption(option)
                        }
                            .listRowSeparatorTint(.secondary)
                    }
                    .listStyle(.plain)
                    .padding(.top, 85)
                }

            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .opacity(showingAll ? 0 : 1)

            VStack {
                PromptSelectionTabBarView(currentTab: $currentTab)
                    .opacity(showingAll ? 0 : 1)
                    .frame(maxHeight: showingAll ? 0 : nil)
                List(self.allPromptOptions) {
                    option in
                    PromptOptionListItemView(option: option) {
                        self.onSelectOption(option)
                    }
                        .listRowSeparatorTint(.secondary)
                }
                .listStyle(.plain)
                .padding(.top, 5)
                .frame(maxWidth: .infinity)
                .overlay(
                    Rectangle()
                        .foregroundColor(.secondary)
                        .opacity(0.2)
                        .frame(height: 1),
                    alignment: .top
                )
                .opacity(!showingAll ? 0 : 1)
            }.animation(.spring(duration: 0.3), value: showingAll)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Back button
                Button(action: { self.showingAll.toggle() }) {
                    Text(self.showingAll ? "Search" : "View All")
                        .font(.system(size: 15))
                        .padding(.horizontal, 5)
                }
                .buttonStyle(.plain)
            }

            ToolbarItem(placement: .principal) {
                Text("Prompts")
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                // Exit button
                Button(action: { self.onClose() }) {
                    Label("Go back", systemImage: "xmark")
                        .font(.system(size: 15))
                        .labelStyle(.iconOnly)
                        .padding(.horizontal, 5)
                }
                .buttonStyle(.plain)
            }
        }

    }
}

struct PromptOptionListItemView: View {
    var option: PromptOption
    var onTab: () -> Void

    var body: some View {
        Button {
            self.onTab()
        } label: {
            Text(option.prompt)
        }.buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        PromptSelectionView(onSelectOption: { option in
            print("option selected \(option)")
        }, onClose: {
            print("closing")
        })
        .environment(PersonalityOnboardingStore())
        .environment(NavigationService())
    }
}
