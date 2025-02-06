//
//  SwiftUIView.swift
//  trailhead
//
//  Created by Robin Götz on 1/27/25.
//

import SwiftUI

enum JournaiButtonStyleVariant {
    case primary
    case secondary
    case accent
    case white
}

struct JournaiButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    let variant: JournaiButtonStyleVariant
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat

    init(
        variant: JournaiButtonStyleVariant = .primary,
        horizontalPadding: CGFloat = 20, verticalPadding: CGFloat = 20
    ) {
        self.variant = variant
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }

    init(variant: JournaiButtonStyleVariant = .primary, padding: CGFloat = 20) {
        self.variant = variant
        self.horizontalPadding = padding
        self.verticalPadding = padding
    }

    // Then update the style properties:
    private var backgroundStyle: some ShapeStyle {
        switch variant {
        case .primary:
            return AnyShapeStyle(
                colorScheme == .light ? Color.black : Color.white)
        case .secondary:
            return AnyShapeStyle(.ultraThickMaterial)
        case .accent:
            return AnyShapeStyle(Color(red: 0.8, green: 0.7, blue: 1.0))
        case .white:
            return AnyShapeStyle(Color.white)
        }
    }

    private var foregroundStyle: some ShapeStyle {
        switch variant {
        case .primary, .accent:
            return AnyShapeStyle(
                colorScheme == .light ? Color.white : Color.black)
        case .secondary:
            return AnyShapeStyle(.foreground)
        case .white:
            return AnyShapeStyle(Color.black)
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .bold()
            .padding(.horizontal, self.horizontalPadding)
            .padding(.vertical, self.verticalPadding)
            .background(self.backgroundStyle)
            .foregroundStyle(self.foregroundStyle)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .opacity(isEnabled ? 1 : 0.6)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Style Extension
extension ButtonStyle where Self == JournaiButtonStyle {
    static var jPrimary: JournaiButtonStyle { JournaiButtonStyle() }
    static func jPrimary(padding: CGFloat = 20) -> JournaiButtonStyle {
        JournaiButtonStyle(variant: .primary, padding: padding)
    }
    static func jPrimary(horizontalPadding: CGFloat = 20, verticalPadding: CGFloat = 20) -> JournaiButtonStyle {
        JournaiButtonStyle(variant: .primary, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding)
    }
    
    static var jSecondary: JournaiButtonStyle {
        JournaiButtonStyle(variant: .secondary)
    }
    static func jSecondary(padding: CGFloat = 20) -> JournaiButtonStyle {
        JournaiButtonStyle(variant: .secondary, padding: padding)
    }
    static func jSecondary(horizontalPadding: CGFloat = 20, verticalPadding: CGFloat = 20) -> JournaiButtonStyle {
        JournaiButtonStyle(variant: .secondary, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding)
    }
    
    static var jAccent: JournaiButtonStyle {
        JournaiButtonStyle(variant: .accent)
    }
    static func jAccent(padding: CGFloat = 20) -> JournaiButtonStyle {
        JournaiButtonStyle(variant: .accent, padding: padding)
    }
    static func jAccent(horizontalPadding: CGFloat = 20, verticalPadding: CGFloat = 20) -> JournaiButtonStyle {
        JournaiButtonStyle(variant: .accent, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding)
    }
    
    static var jWhite: JournaiButtonStyle {
        JournaiButtonStyle(variant: .white)
    }
    static func jWhite(padding: CGFloat = 20) -> JournaiButtonStyle {
        JournaiButtonStyle(variant: .white, padding: padding)
    }
    static func jWhite(horizontalPadding: CGFloat = 20, verticalPadding: CGFloat = 20) -> JournaiButtonStyle {
        JournaiButtonStyle(variant: .white, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding)
    }
}

struct JournaiButtonStyleExamplesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button(action: { print("Yo") }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.jPrimary)

            Button("Delete", role: .destructive) {}
                .buttonStyle(.jSecondary)
            
            Button("Football", role: .destructive) {}
                .buttonStyle(.jAccent)

            Button("Cancel", role: .cancel) {}
                .buttonStyle(.jPrimary)

            Button("Disabled Button") {}
                .buttonStyle(.jPrimary)
                .disabled(true)

            Button("Continue") {}
                .buttonStyle(.jWhite)
        }
        .padding()
    }
}

#Preview {
    JournaiButtonStyleExamplesView()
}
