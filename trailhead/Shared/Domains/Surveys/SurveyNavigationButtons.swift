//
//  SurveyNavigationButtons.swift
//  trailhead
//
//  Created by Robin Götz on 2/25/25.
//
import SwiftUI

struct SurveyNavigationButtons: View {
    let onPrevious: () -> Void
    let onNext: () -> Void
    let isFirstQuestion: Bool
    let isLastQuestion: Bool
    let canMoveNext: Bool
    
    var body: some View {
        HStack {
            Button(action: onPrevious) {
                HStack {
                    Image(systemName: "chevron.left")
                        .buttonIconLabelStyle()
                }
                .padding()
                .accessibilityLabel(isFirstQuestion ? "Cancel survey" : "Previous question")
                .opacity(isFirstQuestion ? 0 : 1)
            }
            
            Spacer()
            
            Button(action: onNext) {
                    Label {
                        Text(isLastQuestion ? "Complete Section" : "Next")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "chevron.right")
                            .accessibilityHidden(true)
                    }.labelStyle(.titleOnly)
              
                .padding()
            }
            .disabled(!canMoveNext)
            .accessibilityLabel(isLastQuestion ? "Complete survey" : "Next question")
            .accessibilityHint(canMoveNext ? "Continue " : "Select an answer to continue")
        }
        .padding()
    }
}

// MARK: - ButtonIconLabelStyle Extension

extension Image {
    func buttonIconLabelStyle() -> some View {
        self
            .imageScale(.medium)
            .foregroundColor(Color.accentColor)
    }
}

// MARK: - SurveyNavigationButtons Previews

#Preview("Normal State") {
    SurveyNavigationButtons(
        onPrevious: {},
        onNext: {},
        isFirstQuestion: false,
        isLastQuestion: false,
        canMoveNext: true
    )
    .padding()
    .accentColor(.blue) // Setting accent color for preview
}

#Preview("First Question") {
    SurveyNavigationButtons(
        onPrevious: {},
        onNext: {},
        isFirstQuestion: true,
        isLastQuestion: false,
        canMoveNext: true
    )
    .padding()
    .accentColor(.blue)
}

#Preview("Last Question") {
    SurveyNavigationButtons(
        onPrevious: {},
        onNext: {},
        isFirstQuestion: false,
        isLastQuestion: true,
        canMoveNext: true
    )
    .padding()
    .accentColor(.blue)
}

#Preview("Cannot Move Next") {
    SurveyNavigationButtons(
        onPrevious: {},
        onNext: {},
        isFirstQuestion: false,
        isLastQuestion: false,
        canMoveNext: false
    )
    .padding()
    .accentColor(.blue)
}
