//
//  JourneyCard.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//
import SwiftUI

struct JourneyCard: View {
    let journey: Journey
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.jAccent.opacity(0.3))
                    .overlay(
                        PatternOverlay(pattern: Pattern.dots)
                            .opacity(0.1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
         
                VStack(alignment: .leading, spacing: 8) {
                    // Journey Title
                    Text(journey.title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    // Journey Description
                    Text(journey.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                    
                    Spacer()
                    
                    // Progress Indicator
                    ProgressView(value: journey.progressPercentage)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .padding(.top, 4)
                    
                    // Session Progress Text
                    Text("\(journey.completedSessions) / \(journey.sessions.count) Sessions Completed")
                        .font(.caption)
                        .foregroundColor(.white)
                        .bold()
                    
                }
                .padding()
            }
               
                .cornerRadius(16)
                .shadow(radius: 4)
                .frame(minHeight: 190, maxHeight: 250)
            
        }
        .buttonStyle(.plain)
    }
}
#Preview {
    JourneyCard(journey: .preview, onTap: { })
}
