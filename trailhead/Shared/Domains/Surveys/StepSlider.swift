//
//  StepSlider.swift
//  trailhead
//
//  Created by Robin Götz on 2/24/25.

import SwiftUI
import UIKit

// MARK: - UIKit Slider Wrapper

struct UIKitSlider: UIViewRepresentable {
    @Binding var value: Float
    var range: ClosedRange<Float>
    var step: Float?
    var minimumValueImage: UIImage?
    var maximumValueImage: UIImage?
    var minimumTrackTintColor: UIColor?
    var maximumTrackTintColor: UIColor?
    var thumbTintColor: UIColor?
    var isContinuous: Bool
    var onEditingChanged: ((Bool) -> Void)?

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = range.lowerBound
        slider.maximumValue = range.upperBound
        slider.value = value
        slider.minimumValueImage = minimumValueImage
        slider.maximumValueImage = maximumValueImage

        if let minimumTrackTintColor = minimumTrackTintColor {
            slider.minimumTrackTintColor = minimumTrackTintColor
        }

        if let maximumTrackTintColor = maximumTrackTintColor {
            slider.maximumTrackTintColor = maximumTrackTintColor
        }

        if let thumbTintColor = thumbTintColor {
            slider.thumbTintColor = thumbTintColor
        }

        slider.isContinuous = isContinuous

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        // Only update the slider value if it's significantly different
        // This prevents issues when the user is dragging
        if abs(uiView.value - value) > 0.01 {
            uiView.value = value
        }

        uiView.minimumValue = range.lowerBound
        uiView.maximumValue = range.upperBound
        uiView.minimumValueImage = minimumValueImage
        uiView.maximumValueImage = maximumValueImage

        if let minimumTrackTintColor = minimumTrackTintColor {
            uiView.minimumTrackTintColor = minimumTrackTintColor
        }

        if let maximumTrackTintColor = maximumTrackTintColor {
            uiView.maximumTrackTintColor = maximumTrackTintColor
        }

        if let thumbTintColor = thumbTintColor {
            uiView.thumbTintColor = thumbTintColor
        }

        uiView.isContinuous = isContinuous
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        let parent: UIKitSlider

        init(_ parent: UIKitSlider) {
            self.parent = parent
        }

        @objc func valueChanged(_ sender: UISlider) {
            let newValue: Float

            // Apply step if provided
            if let step = parent.step, step > 0 {
                let steps = round(
                    (sender.value - parent.range.lowerBound) / step)
                newValue = parent.range.lowerBound + steps * step

                // Only update the slider if the value would be different
                if abs(sender.value - newValue) > 0.01 {
                    sender.value = newValue
                }
            } else {
                newValue = sender.value
            }

            parent.value = newValue
            parent.onEditingChanged?(sender.isTracking)
        }
    }
}

// MARK: - StepSlider Component

struct StepSlider: View {
    @Binding var value: Float
    var range: ClosedRange<Float>
    var step: Float
    var labels: [Int: String]
    var minimumValueImage: UIImage?
    var maximumValueImage: UIImage?
    var minimumTrackColor: Color
    var maximumTrackColor: Color
    var thumbColor: Color
    var isContinuous: Bool
    var onChanged: ((Float) -> Void)?

    init(
        value: Binding<Float>,
        in range: ClosedRange<Float> = 1...5,
        step: Float = 1.0,
        labels: [Int: String] = [:],
        minimumValueImage: UIImage? = nil,
        maximumValueImage: UIImage? = nil,
        minimumTrackColor: Color = .jAccent,
        maximumTrackColor: Color = Color(.systemGray5),
        thumbColor: Color = .white,
        isContinuous: Bool = true,
        onChange: ((Float) -> Void)? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.labels = labels
        self.minimumValueImage = minimumValueImage
        self.maximumValueImage = maximumValueImage
        self.minimumTrackColor = minimumTrackColor
        self.maximumTrackColor = maximumTrackColor
        self.thumbColor = thumbColor
        self.isContinuous = isContinuous
        self.onChanged = onChange
    }

    var body: some View {
        VStack(spacing: 8) {
            UIKitSlider(
                value: $value,
                range: range,
                step: step,
                minimumValueImage: minimumValueImage,
                maximumValueImage: maximumValueImage,
                minimumTrackTintColor: UIColor(minimumTrackColor),
                maximumTrackTintColor: UIColor(maximumTrackColor),
                thumbTintColor: UIColor(thumbColor),
                isContinuous: isContinuous,
                onEditingChanged: { isEditing in
                    if !isEditing {
                        onChanged?(value)
                    }
                }
            )
            .frame(height: 30)

            // Display labels if provided
            if !labels.isEmpty {
                labelsView
            }
        }
    }
    
    var topIndex: Int  {
        Int(range.upperBound - range.lowerBound )
    }
    private var labelsView: some View {
        HStack {
            ForEach(
                0..<topIndex + 1, id: \.self
            ) { index in
                let labelValue = Int(range.lowerBound) + index
                if index == 0 || index == topIndex {
                    if let label = labels[labelValue] {
                        Text(label)
                            .font(.caption)
                            .foregroundColor(
                                Int(value) == labelValue ? .jAccent : .gray
                            )
                            .frame(maxWidth: .infinity, alignment: index == 0 ? .leading : .trailing)
                            .bold()
                    } else {
                        Text("\(labelValue)")
                            .font(.caption)
                            .foregroundColor(
                                Int(value) == labelValue ? .jAccent : .gray
                            )
                            .frame(maxWidth: .infinity, alignment: index == 0 ? .leading : .trailing)
                            .bold()
                    }
                } else {
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Preview Provider
#Preview {
    NavigationView {
        List {
            Section(header: Text("Basic Slider")) {
                BasicSliderPreview()
            }

            Section(header: Text("Custom Range & Steps")) {
                CustomRangePreview()
            }

            Section(header: Text("With Labels")) {
                LabeledSliderPreview()
            }

            Section(header: Text("With Images")) {
                SliderWithImagesPreview()
            }

            Section(header: Text("Custom Colors")) {
                CustomColorsPreview()
            }

            Section(header: Text("Interactive Demo")) {
                InteractivePreview()
            }
        }
        .navigationTitle("UIKitSlider Examples")
    }
}

// MARK: - Individual Preview Components

struct BasicSliderPreview: View {
    @State private var value: Float = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Basic slider (1-5, step: 1)")
                .font(.headline)

            StepSlider(value: $value)

            Text("Selected value: \(Int(value))")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct CustomRangePreview: View {
    @State private var value: Float = 50

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Custom range (0-100, step: 25)")
                .font(.headline)

            StepSlider(
                value: $value,
                in: 0...100,
                step: 25
            )

            Text("Selected value: \(Int(value))")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct LabeledSliderPreview: View {
    @State private var value: Float = 2

    private let labels: [Int: String] = [
        1: "Poor",
        2: "Fair",
        3: "Good",
        4: "Great",
        5: "Excellent",
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("With custom labels")
                .font(.headline)

            StepSlider(
                value: $value,
                labels: labels
            )

            Text("Rating: \(labels[Int(value)] ?? "")")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct SliderWithImagesPreview: View {
    @State private var value: Float = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("With value images")
                .font(.headline)

            StepSlider(
                value: $value,
                minimumValueImage: UIImage(systemName: "speaker.fill"),
                maximumValueImage: UIImage(systemName: "speaker.wave.3.fill")
            )

            Text("Volume: \(Int(value))")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct CustomColorsPreview: View {
    @State private var value: Float = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Custom colors")
                .font(.headline)

            StepSlider(
                value: $value,
                minimumTrackColor: .gray.opacity(0.3),
                maximumTrackColor: .gray.opacity(0.3),
                thumbColor: .jAccent
            )

            Text("Value: \(Int(value))")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct InteractivePreview: View {
    @State private var sliderValue: Float = 2
    @State private var lastChanged: String = "Not changed yet"

    private let temperatureLabels: [Int: String] = [
        1: "Cold",
        2: "Cool",
        3: "Warm",
        4: "Hot",
        5: "Very Hot",
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Interactive with onChange callback")
                .font(.headline)

            StepSlider(
                value: $sliderValue,
                labels: temperatureLabels,
                onChange: { newValue in
                    lastChanged =
                        "Changed to: \(Int(newValue)) (\(temperatureLabels[Int(newValue)] ?? ""))"
                }
            )

            Text(lastChanged)
                .foregroundColor(.secondary)
                .italic()

            Button(action: {
                sliderValue = Float(Int.random(in: 1...5))
            }) {
                Text("Randomize Value")
                    .padding()
                    .background(Color.jAccent)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
