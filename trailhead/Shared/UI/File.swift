//
//  File.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

import SwiftUI

public struct WrappingCollectionView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let spacing: CGFloat
    private let singleItemHeight: CGFloat
    private let content: (Data.Element) -> Content
    @State private var totalHeight: CGFloat = .zero
    
    public init(
        data: Data,
        spacing: CGFloat = 8,
        singleItemHeight: CGFloat,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.spacing = spacing
        self.singleItemHeight = singleItemHeight
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                generateContent(in: geometry)
                    .background(GeometryReader { geo in
                        Color.clear.preference(key: HeightPreferenceKey.self, value: geo.size.height)
                    })
            }
        }
        .onPreferenceChange(HeightPreferenceKey.self) { height in
            totalHeight = height
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(data) { item in
                content(item)
                    .alignmentGuide(
                        .leading,
                        computeValue: { dimension in
                            if abs(width - dimension.width) > geometry.size.width {
                                width = 0
                                height -= dimension.height + spacing
                            }
                            
                            let result = width
                            if item.id == data.last?.id {
                                width = 0
                            } else {
                                width -= dimension.width + spacing
                            }
                            return result
                        }
                    )
                    .alignmentGuide(
                        .top,
                        computeValue: { _ in
                            let result = height
                            if item.id == data.last?.id {
                                height = 0
                            }
                            return result
                        }
                    )
            }
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}



struct Location: Identifiable {
    var id: Int
    var name: String
}
// Example usage:
#Preview {
    // Test data
    let locations = [
        Location(id: 1, name: "New York"),
        Location(id: 2, name: "Los Angeles"),
        Location(id: 3, name: "Chicago"),
        Location(id: 4, name: "Houston"),
        Location(id: 5, name: "Phoenix"),
        Location(id: 6, name: "Philadelphia"),
        Location(id: 7, name: "San Francisco"),
        Location(id: 8, name: "Seattle"),
        Location(id: 9, name: "Miami"),
        Location(id: 10, name: "Boston"),
        Location(id: 11, name: "Denver"),
        Location(id: 12, name: "Austin"),
        Location(id: 13, name: "Nashville"),
        Location(id: 14, name: "Portland"),
        Location(id: 15, name: "Las Vegas")
    ]
    
    WrappingCollectionView(
            data: locations,
            spacing: 10, // Spacing between items both horizontally and vertically
            singleItemHeight: 40 // Height for each item
        ) { location in
            ZStack {
                Color.gray.opacity(0.2)
                    .cornerRadius(12)
                
                Button(action: {
                    print(location)
                }) {
                        Text(location.name)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .frame(height: 40) // Match the height of the item
            }
            .fixedSize(horizontal: true, vertical: true)
        }
}
