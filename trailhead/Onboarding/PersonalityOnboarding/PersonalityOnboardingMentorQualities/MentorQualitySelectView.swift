//
//  MentorQualitySelectView.swift
//  trailhead
//
//  Created by Robin Götz on 1/20/25.
//

import SwiftUI

struct MentorQualitySelectView: View {
    @Environment(PersonalityOnboardingStore.self) private var store

    var body: some View {
        WrappingCollectionView(
            data: ALL_MENTOR_QUALITIES,
            spacing: 10,  // Spacing between items both horizontally and vertically
            singleItemHeight: 40  // Height for each item
        ) { quality in
            Toggle(
                quality.name,
                isOn: Binding(
                    get: { self.store.selectedMentorQualities.contains(quality) },
                    set: { isOn in
                        if isOn {
                            self.store.selectQuality(quality)
                        } else {
                            self.store.deselectQuality(quality)
                        }
                    }
                )
            ).toggleStyle(.button).buttonStyle(.bordered)
                .fixedSize(horizontal: true, vertical: true)
        }
    }
}

#Preview {
    MentorQualitySelectView().environment(PersonalityOnboardingStore())
}
