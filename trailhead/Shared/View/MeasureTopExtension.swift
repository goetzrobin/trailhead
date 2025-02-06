//
//  MeasureTopExtension.swift
//  trailhead
//
//  Created by Robin Götz on 1/29/25.
//
import SwiftUI

extension View {
    func measureTop(
        in coordinateSpace: CoordinateSpace,
        perform: @escaping (CGFloat) -> Void
    ) -> some View {
        overlay(alignment: .top) {
            GeometryReader { proxy in
                let top = proxy.frame(in: coordinateSpace).minY
                Color.clear
                    .onAppear {
                        perform(top)
                    }.onChange(of: top) { _, newValue in perform(newValue)}
            }
        }
    }
}
