//
//  SurveyContainer.swift
//  trailhead
//
//  Created by Robin Götz on 2/25/25.
//
import SwiftUI

struct SurveyContainerView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Bindable var surveyState: SurveyState
    let onBack: () -> Void
    let onComplete: () -> Void

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text(
                    surveyState.survey.description
                ).font(.subheadline).foregroundStyle(.secondary)
                    .padding(.horizontal)
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(
                        Array(surveyState.survey.questions.enumerated()),
                        id: \.offset
                    ) { index, surveyQuestion in
                        QuestionView(
                            question: surveyQuestion,
                            currentValue: surveyState.survey.answers[index]?
                                .value ?? 3,
                            onAnswerSelected: { value in
                                surveyState.dispatch(
                                    .answerQuestion(
                                        forIndex: index, value: value)
                                )
                            }
                        )
                        .background(
                            self.colorScheme == .light
                                ? Color(.systemBackground)
                                : Color.secondary.opacity(0.12)
                        )
                        .cornerRadius(10)
                        .shadow(
                            color: (self.colorScheme == .light
                                ? Color.black : Color.white).opacity(0.1),
                            radius: 5,
                            x: 0,
                            y: 2)

                    }
                }
                .padding()

                Button(action: onComplete) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.jPrimary)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.horizontal)

                Button("Go back") { onBack() }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(surveyState.survey.title)
        .navigationBarTitleDisplayMode(.large)

    }
}

#Preview {
    let surveyState = SurveyState(
        survey: SurveyData.careerExplorationBreadthSelfSurvey)
    NavigationStack {
        SurveyContainerView(
            surveyState: surveyState,
            onBack: {},
            onComplete: {}
        )
    }
}
