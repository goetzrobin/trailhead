//
//  SelectionSectionsView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//
import SwiftUI

struct SelectionSectionsView: View {
    @Environment(PersonalityOnboardingExcitedAboutStore.self) private var store

    var body: some View {
        ForEach(INTEREST_CATEGORIES) { category in
                SelectionSectionView(
                    title: category.name, iconName: category.iconName
                ) {
                    SeeMoreView {
                        WrappingCollectionView(
                            data: category.interests,
                            spacing: 10,  // Spacing between items both horizontally and vertically
                            singleItemHeight: 40  // Height for each item
                        ) { interest in
                            Toggle(
                                interest.name,
                                isOn: Binding(
                                    get: { self.store.selectedInterests.contains(interest) },
                                    set: { isOn in
                                        if isOn {
                                            self.store.selectInterest(interest)
                                        } else {
                                            self.store.deselectInterest(interest)
                                        }
                                    }
                                )
                            ).toggleStyle(JournaiToggleStyle())
                                .fixedSize(horizontal: true, vertical: true)
                        }
                    }
                }
            }

    }
}

#Preview {
    SelectionSectionsView().environment(PersonalityOnboardingExcitedAboutStore())
}
