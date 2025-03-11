//
//  MentorMessageView.swift
//  trailhead
//
//  Created by Robin Götz on 3/10/25.
//
import SwiftUI

struct MentorMessageView: View {
    let message: String
    let isComplete: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(message)
                .multilineTextAlignment(.leading)
            HStack {
                CopyButton(textToCopy: message)
            }
            .padding(10)
            .opacity(self.isComplete ? 1 : 0)
            .disabled(!self.isComplete)
        }.frame(maxWidth: .infinity, alignment: .topLeading)
    }
}


