//
//  JournaiToggleStyle.swift
//  trailhead
//
//  Created by Robin Götz on 1/28/25.
//

import SwiftUI

struct JournaiToggleStyle: ToggleStyle {
    var fontSize = 13.0
    var horizontalPadding = 18.0
    var verticalPadding = 12.0
    func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation {
                configuration.isOn.toggle()
            }
        } label: {
            configuration.label
                .font(.system(size: self.fontSize))
        }
        .buttonStyle(
            configuration.isOn
            ? .jAccent(horizontalPadding: self.horizontalPadding, verticalPadding: self.verticalPadding)
                : .jSecondary(horizontalPadding: self.horizontalPadding,verticalPadding: self.verticalPadding)
        )
        .animation(.spring, value: configuration.isOn)
    }
}

#Preview {
    @Previewable @State var isOn = true
    Toggle("Football", isOn: $isOn)
        .toggleStyle(JournaiToggleStyle())
}
