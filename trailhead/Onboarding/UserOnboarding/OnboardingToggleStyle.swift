//
//  OnboardingToggleStyle.swift
//  trailhead
//
//  Created by Robin Götz on 3/3/25.
//
import SwiftUI

extension View {
    func onboardingToggleStyle() -> some View {
        self.toggleStyle(JournaiToggleStyle(fontSize: 15, horizontalPadding: 18, verticalPadding: 4))
    }
}
