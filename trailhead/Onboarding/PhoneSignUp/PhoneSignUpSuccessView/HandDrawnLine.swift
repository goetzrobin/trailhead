//
//  HandDrawnLine.swift
//  trailhead
//
//  Created by Robin Götz on 1/16/25.
//
import Foundation
import SwiftUI

struct HandDrawnLine: Shape {
    // For the drawing animation
    var percentage: CGFloat

    var animatableData: CGFloat {
        get { percentage }
        set { percentage = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        // Start at top right
        path.move(to: CGPoint(x: 0, y: 0))

        // Create random control points for the line
        // Predefined points as ratios of width/height
        // Format: (xOffset from right, yPosition)
        let points: [(CGFloat, CGFloat)] = [
            (405, -0.10),
            (305, 0.15),
            (408, 0.75),
            (50, 0.20),
            (158, 0.85),
            (-100, 0.20),
            (-50, 1.0),
            (30, 1.4),
        ]

        // Convert ratios to actual points
        let actualPoints = points.map { point in
            CGPoint(
                x: width - point.0,
                y: height * point.1
            )
        }

        // Draw the path
        path.move(to: actualPoints[0])

        for i in 1..<actualPoints.count {
            let point = actualPoints[i]
            let previousPoint = actualPoints[i - 1]
            let midPoint = CGPoint(
                x: (previousPoint.x + point.x) / 2,
                y: (previousPoint.y + point.y) / 2
            )
            path.addQuadCurve(to: midPoint, control: previousPoint)
        }

        // Trim the path based on percentage for animation
        return path.trimmedPath(from: 0, to: percentage)
    }
}
