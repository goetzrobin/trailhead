//
//  QuestionView.swift
//  trailhead
//
//  Created by Robin Götz on 2/25/25.
//
import SwiftUI

struct QuestionView: View {
    @State private var sliderValue: Float
    let question: SurveyQuestion
    let onAnswerSelected: (Int) -> Void

    init(
        question: SurveyQuestion, currentValue: Int? = nil,
        onAnswerSelected: @escaping (Int) -> Void
    ) {
        self.question = question
        self._sliderValue = State(initialValue: Float(currentValue ?? 3))
        self.onAnswerSelected = onAnswerSelected
    }

    private var likertLabels: [Int: String] {
        var labels: [Int: String] = [:]
        for answer in question.possibleAnswers {
            labels[answer.value] = answer.label
        }
        return labels
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Question text
            Text(question.question)
                .font(.title3)
                .fontWeight(.medium)
                .padding(.bottom, 10)

            HStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        sliderValue == 1
                            ? Color.jAccent : Color.secondary.opacity(0.3)
                    )
                    .animation(.spring, value: sliderValue)
                    .frame(width: 15, height: 250)
                    .padding(.leading, 4)
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        sliderValue == 2
                            ? Color.jAccent : Color.secondary.opacity(0.3)
                    )
                    .animation(.spring, value: sliderValue)
                    .frame(width: 15, height: 200)
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        sliderValue == 3
                            ? Color.jAccent : Color.secondary.opacity(0.3)
                    )
                    .animation(.spring, value: sliderValue)
                    .frame(width: 15, height: 150)
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        sliderValue == 4
                            ? Color.jAccent : Color.secondary.opacity(0.3)
                    )
                    .animation(.spring, value: sliderValue)
                    .frame(width: 15, height: 200)
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        sliderValue == 5
                            ? Color.jAccent : Color.secondary.opacity(0.3)
                    )
                    .animation(.spring, value: sliderValue)
                    .frame(width: 15, height: 250)
                    .padding(.trailing, 4)

            }

            // Slider
            StepSlider(
                value: $sliderValue,
                in: 1...5,
                step: 1,
                labels: likertLabels,
                minimumTrackColor: .gray.opacity(0.3),
                maximumTrackColor: .gray.opacity(0.3),
                thumbColor: .jAccent,
                onChange: { newValue in
                    let intValue = Int(newValue)
                    onAnswerSelected(intValue)
                }
            )
            .padding(.bottom, 10)

            Text(likertLabels[Int(sliderValue)] ?? "")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)

        }
        .padding(30)
        .onChange(of: sliderValue) { oldValue, newValue in
            // This triggers on direct changes to sliderValue (initial setup)
            if Int(oldValue) != Int(newValue) {
                onAnswerSelected(Int(newValue))
            }
        }
    }
}

// MARK: - QuestionView Preview
#Preview {
    let title = "Question Previews"
    let description = "lorem ipsum"
    let questions = SurveyData.careerIdentityConfusionSurvey.questions
    let onAnswerSelected: (Int, Int) -> Void = { index, value in
        print(
            "question answered at index \(index): \(value)"
        )
    }
    let onContinue: () -> Void = { print("Continue") }
    let onBack: () -> Void = { print("Back") }
    NavigationStack {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text(
                    description
                ).font(.subheadline).foregroundStyle(.secondary)
                    .padding(.horizontal)
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(questions.enumerated()), id: \.offset) { index, surveyQuestion in
                        QuestionView(
                            question: surveyQuestion,
                            currentValue: 3,
                            onAnswerSelected: { value in
                                onAnswerSelected(index, value)
                            }
                        )
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(
                            color: Color.black.opacity(0.1), radius: 5, x: 0,
                            y: 2)

                    }
                }
                .padding()

                Button(action: onContinue) {
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
        .navigationTitle(title)
    }
}
