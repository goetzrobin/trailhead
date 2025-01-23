import SwiftUI

@IBDesignable
class CustomSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 10
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}

class SliderViewController: UIViewController {
    private let slider: CustomSlider
    var valueChanged: ((Float) -> Void)?
    
    init(value: Float, minValue: Float, maxValue: Float, thumbColor: UIColor, minTrackColor: UIColor, maxTrackColor: UIColor) {
        self.slider = CustomSlider(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.value = value
        
        slider.addTarget(
            self,
            action: #selector(sliderValueChanged(_:)),
            for: .valueChanged
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: view.topAnchor),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        valueChanged?(sender.value)
    }
    
    func updateValue(_ newValue: Float) {
        UIView.animate(withDuration: 0.3) {
            self.slider.setValue(newValue, animated: true)
        }
    }
}

struct PersistentSliderView: UIViewControllerRepresentable {
    @Binding var value: Float
    var minValue: Float = 1.0
    var maxValue: Float = 100.0
    var thumbColor: UIColor = .white
    var minTrackColor: UIColor = .blue
    var maxTrackColor: UIColor = .lightGray
    
    func makeUIViewController(context: Context) -> SliderViewController {
        let controller = SliderViewController(
            value: value,
            minValue: minValue,
            maxValue: maxValue,
            thumbColor: thumbColor,
            minTrackColor: minTrackColor,
            maxTrackColor: maxTrackColor
        )
        controller.valueChanged = { newValue in
            value = newValue
        }
        return controller
    }
    
    func updateUIViewController(_ controller: SliderViewController, context: Context) {
        controller.updateValue(value)
    }
}

struct PersonalityOnboardingWrapperProgressIndicatorView: View {
    @Environment(PersonalityOnboardingStore.self) private var store
    
    var body: some View {
        @Bindable var store = self.store
        PersistentSliderView(
            value: Binding(
                get: { Float(store.currentStep) },
                set: { _ in } // No-op setter since it's read-only
            ),
            minValue: 0,
            maxValue: Float(store.maxSteps),
            thumbColor: .clear,
            minTrackColor: .white,
            maxTrackColor: .gray
        )
        .padding(.top, -1)
        .frame(width: 125)
    }
}

#Preview {
    PersonalityOnboardingWrapperProgressIndicatorView()
        .environment(PersonalityOnboardingStore())
}
