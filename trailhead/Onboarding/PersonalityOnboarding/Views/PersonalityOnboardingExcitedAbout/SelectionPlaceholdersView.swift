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
                let radius: CGFloat = 18
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
                .font(.system(size: 13))
                .foregroundStyle(.foreground)
        }
        .opacity(0.2)
        .padding(5)
        .frame(height: 50)
    }
}

struct SelectionPlaceholdersView: View {
    let selectedOptions: [ExcitedAboutOption]
    let onSelectionTap: (_ option: ExcitedAboutOption) -> Void
    
    @State private var previousCount: Int = 0
    
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
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(Array(selectedOptions), id: \.id) { option in
                            OptionView(option: option) {
                                withAnimation {
                                    self.onSelectionTap(option)
                                }
                            }
                            .id(option.id)
                        }
                        
                        ForEach(min(3, selectedOptions.count)..<3, id: \.self) { index in
                            IconBox(iconName: self.pickPlaceholderIcon(for: index))
                                .transition(.scale.combined(with: .opacity))
                                .frame(width: boxWidth)
                        }
                    }
                    .frame(height: 60)
                }
                // Add onChange modifier to detect when items are added
                .onChange(of: selectedOptions.count) { oldValue, newValue in
                    if let lastItem = selectedOptions.last {
                        // Animate scroll to the last item
                        withAnimation {
                            scrollProxy.scrollTo(lastItem.id, anchor: newValue > oldValue ? .trailing : .leading)
                        }
                    }
                }
            }
        }
        .frame(height: 50)
    }
}

struct OptionView: View {
    let option: ExcitedAboutOption
    let onTap: () -> Void
    
    var fontSize = 13.0
    var horizontalPadding = 18.0
    var verticalPadding = 12.0

    var body: some View {
        Button(option.name) {
            self.onTap()
        }
        .font(.system(size: self.fontSize))
        .buttonStyle(.jAccent(horizontalPadding: self.horizontalPadding, verticalPadding: self.verticalPadding))
        .padding(.trailing, 10)
    }
}

#Preview {
    SelectionPlaceholdersView(selectedOptions: []) {option in 
        print("unselect here \(option.name)")
    }
}
