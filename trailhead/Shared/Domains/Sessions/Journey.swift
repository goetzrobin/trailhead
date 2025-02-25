//
//  Journey.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//
import Foundation
import SwiftUI

struct Journey: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let backgroundColor: Color
    let pattern: Pattern
    let sessions: [Session]  // Each journey has multiple sessions

    var completedSessions: Int {
        sessions.filter { $0.isCompleted }.count
    }

    var progressPercentage: Double {
        guard !sessions.isEmpty else { return 0 }
        return Double(completedSessions) / Double(sessions.count)
    }

    static var preview = Journey(
        id: UUID(),
        title: "Mindfulness",
        description: "Learn mindfulness techniques to reduce stress.",
        backgroundColor: .blue,
        pattern: .dots,
        sessions: []
    )
}
