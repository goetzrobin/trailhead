//
//  SelectionSectionsView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//
import SwiftUI

struct SelectionSectionsView: View {
    @Environment(PersonalityOnboardingStore.self) private var store

    var body: some View {
            ForEach(SECTIONS) { section in
                SelectionSectionView(
                    title: section.id, iconName: section.iconName
                ) {
                    SeeMoreView {
                        WrappingCollectionView(
                            data: section.options,
                            spacing: 10,  // Spacing between items both horizontally and vertically
                            singleItemHeight: 40  // Height for each item
                        ) { option in
                            Toggle(
                                option.name,
                                isOn: Binding(
                                    get: { self.store.selectedExcitedAboutOptions.contains(option) },
                                    set: { isOn in
                                        if isOn {
                                            self.store.selectOption(option)
                                        } else {
                                            self.store.deselectOption(option)
                                        }
                                    }
                                )
                            ).toggleStyle(.button).buttonStyle(.bordered)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                    }
                }
            }

    }
}

#Preview {
    SelectionSectionsView().environment(PersonalityOnboardingStore())
}
