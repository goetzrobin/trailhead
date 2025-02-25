//
//  Patterns.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//
import SwiftUI

enum Pattern: Hashable {
    case dots
    case stripes
    case waves
    case triangles
}

struct PatternOverlay: View {
    let pattern: Pattern
    
    var body: some View {
            switch pattern {
            case .dots:
                DotsPattern()
            case .stripes:
                StripesPattern()
            case .waves:
                WavesPattern()
            case .triangles:
                TrianglesPattern()
            }
    }
}

struct DotsPattern: View {
    var body: some View {
        Path { path in
            let size = 8.0
            let spacing = 24.0
            
            for row in 0...10 {
                for col in 0...10 {
                    let x = CGFloat(col) * spacing
                    let y = CGFloat(row) * spacing
                    path.addEllipse(in: CGRect(x: x, y: y, width: size, height: size))
                }
            }
        }
        .stroke(Color.white, lineWidth: 1)
    }
}

struct StripesPattern: View {
    var body: some View {
        Path { path in
            let spacing = 20.0
            
            for i in 0...20 {
                let y = CGFloat(i) * spacing
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: 1000, y: y))
            }
        }
        .stroke(Color.white, lineWidth: 1)
    }
}

struct WavesPattern: View {
    var body: some View {
        Path { path in
            let height = 20.0
            let width = 40.0
            
            for row in 0...10 {
                var startPoint = CGPoint(x: 0, y: CGFloat(row) * height * 2)
                path.move(to: startPoint)
                
                for _ in 0...10 {
                    let control1 = CGPoint(x: startPoint.x + width/2, y: startPoint.y + height)
                    let control2 = CGPoint(x: startPoint.x + width/2, y: startPoint.y - height)
                    let endPoint = CGPoint(x: startPoint.x + width, y: startPoint.y)
                    
                    path.addCurve(to: endPoint,
                                control1: control1,
                                control2: control2)
                    
                    startPoint = endPoint
                }
            }
        }
        .stroke(Color.white, lineWidth: 1)
    }
}

struct TrianglesPattern: View {
    var body: some View {
        Path { path in
            let size = 20.0
            let spacing = 30.0
            
            for row in 0...10 {
                for col in 0...10 {
                    let x = CGFloat(col) * spacing
                    let y = CGFloat(row) * spacing
                    
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x + size, y: y))
                    path.addLine(to: CGPoint(x: x + size/2, y: y - size))
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        .stroke(Color.white, lineWidth: 1)
    }
}
