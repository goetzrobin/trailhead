//
//  PersonalityOnboardingStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//
import Foundation
import Observation
import SwiftUI

@Observable class PersonalityOnboardingProgressStore {
    let maxSteps: Int = PersonalityPath.totalCases
    private(set) var currentPath: PersonalityPath?
    
    var currentStep: Int {
        guard let currentPath else { return 0 }
        return (PersonalityPath.allCases.firstIndex(of: currentPath) ?? 0) + 1
    }
    
    var currentStepProgress: CGFloat {
        return CGFloat(self.currentStep) / max(CGFloat(self.maxSteps), 1)
    }
    
    func updateCurrentPath(_ path: PersonalityPath) {
        self.currentPath = path
    }
}


