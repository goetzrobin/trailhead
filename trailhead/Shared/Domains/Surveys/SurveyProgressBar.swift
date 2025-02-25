//
//  SurveyProgressBar.swift
//  trailhead
//
//  Created by Robin Götz on 2/25/25.
//
import SwiftUI

struct SurveyProgressBar: View {
    let value: Double
    let title: String?
    
    init(value: Double, title: String? = nil) {
        self.value = value
        self.title = title
    }
    
    var body: some View {
        VStack(spacing: 4) {
            if let title = title {
                HStack {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    // Progress
                    Rectangle()
                        .fill(Color.jAccent)
                        .frame(width: CGFloat(value) * geometry.size.width, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal)
    }
}
