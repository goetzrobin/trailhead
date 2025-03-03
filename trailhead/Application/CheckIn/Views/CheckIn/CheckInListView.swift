//
//  CheckInListView.swift
//  trailhead
//
//  Created by Robin Götz on 2/10/25.
//
import SwiftUI
import Foundation

// MARK: - Check In List View
struct CheckInListView: View {
    let checkIns: [SessionLog]
    var body: some View {
        
        LazyVStack(spacing: 10) {
            ForEach(self.checkIns, id: \.self.id) { checkIn in
                CheckInCard(date: checkIn.createdAt, primaryEmotion: Emotion.pleasantHighEnergy[0], secondaryEmotion: Emotion.pleasantHighEnergy[0])
            }
        }
        .padding(.bottom, 80)
        .opacity(self.checkIns.count == 0 ? 0 : 1)


        VStack {
            Text("No check-ins yet.")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .opacity(self.checkIns.count == 0 ? 1 : 0)
    }
}

#Preview {
    ScrollView {
        CheckInListView(checkIns: [])


        CheckInListView(checkIns: [])
    }
}
