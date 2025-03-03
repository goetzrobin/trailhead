//
//  TopicPicker.swift
//  trailhead
//
//  Created by Robin Götz on 2/25/25.
//
import SwiftUI

// MARK: - Topics Grid View
struct TopicsGridView: View {
    let onTopicSelected: (TopicItem) -> Void
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(TopicsData.items) { item in
                TopicItemView(
                    item: item,
                    onTap: {
                        onTopicSelected(item)
                    })
            }
        }.padding(.bottom, 40)
    }
}

// MARK: - Topic Item View
struct TopicItemView: View {
    let item: TopicItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading) {
                Image(systemName: item.iconName)
                    .font(.system(size: 38))
                    .foregroundColor(.jAccent)
                    .padding(.bottom, 5)
                Spacer()
                Text(item.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
            }
            .padding()
            .frame(height: 200)
            .background(Color.white.opacity(0.1))
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .disabled(true)
        .buttonStyle(PlainButtonStyle())
    }
}
