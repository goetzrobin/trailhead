//
//  MentorQualitySelectView.swift
//  trailhead
//
//  Created by Robin Götz on 1/20/25.
//

import SwiftUI

struct MentorTraitsSelectView: View {
    private let store: PersonalityOnboardingMentorTraitsStore
    
    init(store: PersonalityOnboardingMentorTraitsStore) {
        self.store = store
    }

    var body: some View {
        WrappingCollectionView(
            data: ALL_MENTOR_TRAITS,
            spacing: 10,  // Spacing between items both horizontally and vertically
            singleItemHeight: 40  // Height for each item
        ) { trait in
            Toggle(
                trait.name,
                isOn: Binding(
                    get: { self.store.selectedMentorTraits.contains(trait) },
                    set: { isOn in
                        if isOn {
                            self.store.selectTrait(trait)
                        } else {
                            self.store.deselectTrait(trait)
                        }
                    }
                )
            ).toggleStyle(JournaiToggleStyle())
                .fixedSize(horizontal: true, vertical: true)
        }
    }
}

#Preview {
    MentorTraitsSelectView(store: PersonalityOnboardingMentorTraitsStore())
}
