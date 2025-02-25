//
//  OnboardingStore.swift
//  trailhead
//
//  Created by Robin Götz on 2/12/25.
//
import Foundation
import Observation

// MARK: - Storage Keys
private enum StorageKeys {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
}

// MARK: - Onboarding Manager
@Observable class OnboardingStore {
    var hasCompletedOnboarding: Bool
    
    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: StorageKeys.hasCompletedOnboarding)
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: StorageKeys.hasCompletedOnboarding)
    }
}
