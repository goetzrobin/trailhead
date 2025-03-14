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
    let onCheckInTap: (SessionLog) -> Void
    
    var body: some View {
        
        LazyVStack(spacing: 10) {
            ForEach(self.checkIns, id: \.self.id) { checkIn in
                CheckInCard(date: checkIn.createdAt, summary: checkIn.summary ?? "", isInProgress: checkIn.status == .inProgress) {
                    self.onCheckInTap(checkIn)
                }
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
        CheckInListView(checkIns: []) { _ in print("Yo")}


        CheckInListView(checkIns: []) { _ in print("Yo")}
    }
}
