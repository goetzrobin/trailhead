//
//  ReflectionSlider.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//
import SwiftUI

struct ReflectionSlider: View {
    let title: String
    @Binding var score: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Slider(value: $score.toDoubleBinding(), in: 1...10, step: 1)
            Text("Score: \(score)")
                .font(.caption)
        }
        .padding()
    }
}

// Convert Int Binding to Double Binding
extension Binding where Value == Int {
    func toDoubleBinding() -> Binding<Double> {
        Binding<Double>(
            get: { Double(self.wrappedValue) },
            set: { self.wrappedValue = Int($0) }
        )
    }
}
#Preview {
    ReflectionSlider(title: "Test", score: .constant(5))
}
