//
//  JournaiCircularToggleStyle.swift
//  trailhead
//
//  Created by Robin Götz on 3/4/25.
//

import SwiftUI

struct JournaiCircularToggleStyle: ToggleStyle {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var primaryColor: AnyShapeStyle {
        self.colorScheme == .light ? AnyShapeStyle(.white) : AnyShapeStyle(.black)
    }
    var secondaryColor: AnyShapeStyle {
        self.colorScheme == .light ? AnyShapeStyle(.black) : AnyShapeStyle(.white)
    }
    func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation {
                configuration.isOn.toggle()
            }
        } label: {
            configuration.label
                .frame(
                    width: UIScreen.main.bounds.width * 0.47,
                    height: UIScreen.main.bounds.width * 0.47
                )
                .background(
                    Circle()
                        .stroke(
                            !configuration.isOn ? secondaryColor : primaryColor,
                            lineWidth: 2
                        )
                        .background(
                            !configuration.isOn ?
                            Circle()
                                .fill(primaryColor) :
                                Circle()
                                .fill(secondaryColor)
                        )
                )
                .foregroundStyle(
                    !configuration.isOn ? secondaryColor : primaryColor
                )
                .animation(.spring, value: configuration.isOn)
        }
    }
}

#Preview {
    @Previewable @State var isOn = false
    VStack {
        Text("\(isOn)")
        Toggle("Football", isOn: $isOn)
            .toggleStyle(JournaiCircularToggleStyle())
    }
}
