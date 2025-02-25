//
//  CheckInHeaderView.swift
//  trailhead
//
//  Created by Robin Götz on 2/10/25.
//
import Foundation
import SwiftUI

struct CheckInHeaderView: View {
    let textOpacity: CGFloat
    let textOffset: CGFloat
    let onMeasureTop: (CGFloat) -> Void

    var body: some View {
        Text("How are you feeling this evening?")
            .font(.largeTitle)
            .bold()
            .multilineTextAlignment(.center)
            .lineSpacing(0)
            .opacity(textOpacity)
            .padding(.top, textOffset)
            .measureTop(in: .named("ContainerView"), perform: onMeasureTop)
    }
}

#Preview {
    CheckInHeaderView(textOpacity: 0.8, textOffset: 30, onMeasureTop: { _ in })
}
