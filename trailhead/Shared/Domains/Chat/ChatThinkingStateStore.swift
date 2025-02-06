//
//  ChatThinkingState.swift
//  trailhead
//
//  Created by Robin Götz on 2/6/25.
//
import Foundation
import SwiftUI
import Observation

@Observable class ThinkingStateStore {
    private(set) var isThinking = false
    private(set) var elapsedTime: TimeInterval?
    private(set) var thinkingTime: TimeInterval?
    
    private var startTime: Date?
    private var timer: Timer?
    
    var isActive: Bool {
        get { isThinking }
        set {
            isThinking = newValue
            if newValue {
                startTime = Date()
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                    self?.updateElapsedTime()
                }
            } else {
                thinkingTime = elapsedTime
                timer?.invalidate()
                timer = nil
                startTime = nil
                elapsedTime = nil
            }
        }
    }
    
    private func updateElapsedTime() {
        guard let startTime else { return }
        elapsedTime = Date().timeIntervalSince(startTime)
    }
}
