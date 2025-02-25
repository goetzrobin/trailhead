//
//  SessionRow.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//

import SwiftUI

struct SessionRow: View {
    let session: Session

    var body: some View {
            VStack(alignment: .leading) {
                Text(session.name ?? "Unknown session")
                    .font(.headline)
                Text(session.description ?? "No description")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Estimated time
                HStack {
                    Image(systemName: "clock")
                    Text("\(session.estimatedCompletionTime ?? 0) min")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(session.logs?.count ?? 0)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
  
    }
}

