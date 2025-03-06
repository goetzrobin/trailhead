import Foundation
import SwiftUI

struct CheckInHeaderView: View {
    let textOpacity: CGFloat
    let textOffset: CGFloat
    let onMeasureTop: (CGFloat) -> Void
    
    // Computed property to determine the greeting based on time of day
    private var timeBasedGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "morning"
        case 12..<17:
            return "afternoon"
        case 17..<22:
            return "evening"
        default:
            return "night"
        }
    }
    
    var body: some View {
        Text("How are you feeling this \(timeBasedGreeting)?")
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
