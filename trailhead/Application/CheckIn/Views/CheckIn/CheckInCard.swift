//
//  CheckInCard.swift
//  trailhead
//
//  Created by Robin Götz on 2/10/25.
//
import Foundation
import SwiftUI

// MARK: - Check In Row
struct CheckInCard: View {
    @Environment(\.colorScheme) private var colorScheme
    // Example emotions - in practice you'd pass these in
    let date: Date;
    let primaryEmotion: Emotion;
    let secondaryEmotion: Emotion?

    // Helper function to create slightly randomized points based on index
    //    private func randomizedPoints(forEmotionCount count: Int) -> [[CGF]] {
    //        let basePoints = [
    //            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
    //            [0.0, 0.5], [0.5, 0.4], [1.0, 0.5],
    //            [0.0, 1.0], [0.8, 1.0], [1.0, 1.0]
    //        ]
    //
    //        return basePoints.enumerated().map { index, point in
    //            let randomX = Double.random(in: -0.1...0.1)
    //            let randomY = Double.random(in: -0.1...0.1)
    //            return [
    //                Float(max(0, min(1, point[0] + randomX))),
    //                Float(max(0, min(1, point[1] + randomY)))
    //            ]
    //        }
    //    }

    // Helper function to create colors array with emotion colors
    private func gradientColors() -> [Color] {
        var colors: [Color] = Array(repeating: self.colorScheme == .light ? .white : .black, count: 9)

        // Place first emotion color
        colors[2] = primaryEmotion.color
        colors[5] = primaryEmotion.color
        colors[8] = primaryEmotion.color

        // Place second emotion color if it exists
        colors[1] = (secondaryEmotion ?? primaryEmotion).color
        colors[7] = (secondaryEmotion ?? primaryEmotion).color
        colors[4] = (secondaryEmotion ?? primaryEmotion).color

        return colors
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(
                    MeshGradient(
                        width: 3,
                        height: 3,
                        points: [
                            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                            [0.0, 0.5], [0.5, 0.4], [1.0, 0.5],
                            [0.0, 1.0], [0.8, 1.0], [1.0, 1.0],
                        ],
                        colors: gradientColors()
                    )
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            RoundedRectangle(cornerRadius: 3)
                .fill((self.colorScheme == .light ? Color.white : Color.black).opacity(0.6))

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: -6) {
                        Text(dateFormatter.string(from: date))
                        Text(timeFormatter.string(from: date))
                    }
                    Spacer()
                }
                Spacer()
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: -12) {
                        Text("I'm feeling")
                            .font(.title)
                            .bold()
                            .italic()
                        HStack {

                            Text(primaryEmotion.name.lowercased())
                                .foregroundStyle(primaryEmotion.color)
                                .font(.title)
                                .bold()

                            if let secondaryEmotion = secondaryEmotion {
                                Text("&")
                                    .font(.title)
                                Text(secondaryEmotion.name.lowercased())
                                    .foregroundStyle(secondaryEmotion.color)
                                    .font(.title)
                                    .bold()

                            }
                        }
                    }
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
        .frame(height: 200)
    }
}

#Preview {
    CheckInCard(date: Date(), primaryEmotion: pleasantLowEnergyEmotions[0][0], secondaryEmotion: nil )
}
