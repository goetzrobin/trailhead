//
//  SelectionPlaceholdersView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct IconBox: View {
    let iconName: String

    var body: some View {
        ZStack {
            GeometryReader { geo in
                let strokeWidth: CGFloat = 2
                let radius: CGFloat = 15
                let insettedDiameter = radius * 2 - strokeWidth
                let desiredDash: CGFloat = 6
                // note that we need to take the inset of strokeBorder into account
                // or just use stroke instead of strokeBorder to make this simpler
                let perimeter =
                    (geo.size.width - strokeWidth / 2 - insettedDiameter) * 2  // horizontal straight edges
                    + (geo.size.height - strokeWidth / 2 - insettedDiameter)
                    * 2  // vertical straight edges
                    + (insettedDiameter * .pi)  // the circular parts

                // this finds the smallest adjustedDash such that
                // - perimeter is an integer multiple of adjustedDash
                // - adjustedDash > desiredDash
                let floored = floor(perimeter / desiredDash)
                let adjustedDash =
                    (perimeter - desiredDash * floored) / floored + desiredDash

                RoundedRectangle(cornerRadius: radius)
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: strokeWidth, dash: [adjustedDash]))
            }
            Image(systemName: iconName)
                .font(.system(size: 15))
                .foregroundStyle(.white)
        }
        .padding(5)
        .frame(height: 60)
    }
}

struct SelectionPlaceholdersView: View {
    let selectedOptions: [ExcitedAboutOption]
    let onSelectionTap: (_ option: ExcitedAboutOption) -> Void

    private func pickPlaceholderIcon(for index: Int) -> String {
        switch index {
        case 0: return "radio.fill"
        case 1: return "mountain.2.fill"
        case 2: return "basketball.fill"
        default: return "questionmark"
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let boxWidth = geometry.size.width / 3
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(selectedOptions), id: \.id) { option in
                        OptionView(option: option) {
                            self.onSelectionTap(option)
                        }
                    }

                    ForEach(min(3, selectedOptions.count)..<3, id: \.self) {
                        index in
                        IconBox(iconName: self.pickPlaceholderIcon(for: index))
                            .transition(.scale.combined(with: .opacity))
                            .frame(
                                width: boxWidth)

                    }
                }
                .frame(height: 60)
            }
        }
        .frame(height: 60)
    }
}

struct OptionView: View {
    let option: ExcitedAboutOption
    let onTap: () -> Void

    var body: some View {
        Button(option.name) {
            self.onTap()
        }
        .padding(.horizontal, 30)
        .frame(height: 55)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
        .padding(.trailing, 10)
    }
}

#Preview {
    SelectionPlaceholdersView(selectedOptions: []) {option in 
        print("unselect here \(option.name)")
    }
}
