//
//  UserMessageView.swift
//  trailhead
//
//  Created by Robin Götz on 3/10/25.
//
import SwiftUI

struct UserMessageView: View {
    let message: String
    var body: some View {
        HStack {
            Spacer()
            Text(message)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                }
                .frame(maxWidth: 300, alignment: .trailing)
        }.frame(maxWidth: .infinity)
    }
}
