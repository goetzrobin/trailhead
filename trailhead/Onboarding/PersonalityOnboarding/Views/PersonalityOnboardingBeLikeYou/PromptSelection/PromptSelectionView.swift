//
//  PromptSelectionView.swift
//  trailhead
//
//  Created by Robin Götz on 1/22/25.
//

import SwiftUI

struct PromptSelectionView: View {
    let recordedPromptResponses: [PromptOptionAndResponse?]
    @State private var showingAll = false
    @State private var currentTab: String = PROMPT_CATEGORIES[0].name

    let onSelectOption: (_ option: PromptOption) -> Void
    let onClose: () -> Void

    let allPromptOptions = PROMPT_CATEGORIES.flatMap { category in
        return category.options
    }

    private func isOptionSelected(_ option: PromptOption) -> Bool {
        recordedPromptResponses.contains { $0?.option == option }
    }

    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentTab) {
                ForEach(PROMPT_CATEGORIES, id: \.name) { category in
                    List(category.options) {
                        option in
                        PromptOptionListItemView(
                            option: option,
                            isSelected: isOptionSelected(option)
                        ) {
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
                PromptSelectionTabBarView(
                    currentTab: $currentTab,
                    responses: self.recordedPromptResponses
                )
                .padding(.bottom)
                .overlay(
                    Rectangle()
                        .foregroundColor(.secondary)
                        .opacity(0.2)
                        .frame(height: 1),
                    alignment: .bottom
                )
                .opacity(showingAll ? 0 : 1)
                .frame(maxHeight: showingAll ? 0 : nil)

                List(self.allPromptOptions) {
                    option in
                    PromptOptionListItemView(
                        option: option, isSelected: isOptionSelected(option)
                    ) {
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
                    Text(self.showingAll ? "View Categories" : "View All")
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
    var isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button {
            self.onTap()
        } label: {
            HStack {
                Text(option.prompt)
                    .opacity(isSelected ? 0.8 : 1)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .disabled(isSelected)
    }
}

#Preview {
    NavigationStack {
        PromptSelectionView(
            recordedPromptResponses: [
                nil, nil,
                PromptOptionAndResponse(
                    option: PromptOption(
                        id: UUID(),
                        prompt: "A skill I'm proud of developing is"),
                    response: "Cooking"),
            ],
            onSelectOption: { option in
                print("option selected \(option)")
            },
            onClose: {
                print("closing")
            }
        )
    }
}
