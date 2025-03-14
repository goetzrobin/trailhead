//
//  CheckInCard.swift
//  trailhead
//
//  Created by Robin Götz on 2/10/25.
//
import SwiftUI

struct CheckInCard: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let date: Date
    let summary: String
    let isInProgress: Bool // New property to track status
    let onTap: () -> Void
    
    // Helper function to create colors array with emotion colors
    private func gradientColors() -> [Color] {
        let baseColor = self.colorScheme == .light ? Color.white : Color.gray
        let accentColor = isInProgress ? Color.blue.opacity(0.3) : baseColor
        
        var colors = Array(repeating: baseColor, count: 9)
        // Add accent color to make in-progress items stand out
        if isInProgress {
            colors[4] = accentColor // Center point
            colors[2] = accentColor // Center point
            colors[3] = accentColor // Center point
            colors[7] = accentColor // Center point
        }
        
        return colors
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    var body: some View {
        Button(action: self.onTap, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(
                        MeshGradient(
                            width: 3,
                            height: 3,
                            points: [
                                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                                [0.0, 0.5], [0.5, 0.4], [1.0, 0.5],
                                [0.0, 1.0], [0.8, 1.0], [1.0, 1.0],
                            ],
                            colors: gradientColors()
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                RoundedRectangle(cornerRadius: 32)
                    .fill(self.colorScheme == .light ? Color.white.opacity(0.6) : Color.black.opacity(0.6))
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: -6) {
                            Text(dateFormatter.string(from: date))
                                .fontWeight(.medium)
                            Text(timeFormatter.string(from: date))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 10)
                        
                        Spacer()
                        
                        if isInProgress {
                            Text("In Progress")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.blue.opacity(0.2))
                                )
                                .overlay(
                                    Capsule()
                                        .strokeBorder(Color.blue, lineWidth: 1)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    if !summary.isEmpty {
                        Text(summary)
                            .font(.title)
                            .minimumScaleFactor(0.5)
                            .padding(10)
                    } else if isInProgress {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Continue your check-in")
                                .font(.headline)
                            Text("Tap to complete your conversation with Sam")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(10)
                    } else {
                        Text("No summary available")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(10)
                    }
                }
                .padding()
            }
            .frame(height: 200)
        })
        .buttonStyle(.plain)
        .padding(.horizontal, 4)
        .overlay(
 
                RoundedRectangle(cornerRadius: 32)
                    .strokeBorder(           isInProgress ? Color.blue :Color.secondary.opacity(0.3), lineWidth: 2)
                    .padding(.horizontal, 4)
        )
    }
}

#Preview {
    VStack {
        CheckInCard(
            date: Date(),
            summary: "Great session today!",
            isInProgress: false
        ) {
            print("completed session tapped")
        }
        
        CheckInCard(
            date: Date(),
            summary: "",
            isInProgress: true
        ) {
            print("in-progress session tapped")
        }
    }
    .padding()
}
