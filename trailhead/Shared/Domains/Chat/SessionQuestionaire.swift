import Observation
//
//  PreSessionQuestionaire.swift
//  trailhead
//
//  Created by Robin Götz on 2/21/25.
//
import SwiftUI

// MARK: - Models
struct SessionScores: Equatable, Codable {
    var feelingScore: Int?
    var anxietyScore: Int?
    var motivationScore: Int?

    var isComplete: Bool {
        feelingScore != nil && anxietyScore != nil && motivationScore != nil
    }
}

// MARK: - View Models
@Observable class PreSessionViewModel {
    var currentStep = 0
    var scores = SessionScores()

    let onSessionStart: (_: SessionScores) async -> Void

    init(onSessionStart: @escaping (_: SessionScores) async -> Void) {
        self.onSessionStart = onSessionStart
    }

    func advanceToNextStep() {
        withAnimation {
            if currentStep < 3 {
                currentStep += 1
            }
        }
    }

    func startSession() async {
        guard scores.isComplete else { return }
        await onSessionStart(scores)
    }
}

// MARK: - Custom Components
struct MoodButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                Text(label)
                    .font(.caption)
            }
            .padding()
            .background(
                isSelected ? Color.accentColor.opacity(0.2) : Color.clear
            )
            .cornerRadius(8)
        }
    }
}

// MARK: - Question Views
struct FeelingQuestionView: View {
    @Binding var score: Int?
    let onSelection: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("How are you feeling right now?")
                .font(.title2)
                .bold()

            HStack(spacing: 12) {
                ForEach(0...3, id: \.self) { value in
                    MoodButton(
                        icon: moodIcon(for: value),
                        label: moodLabel(for: value),
                        isSelected: score == value
                    ) {
                        score = value
                        onSelection()
                    }
                }
            }
        }
        .padding()
    }

    private func moodIcon(for value: Int) -> String {
        switch value {
        case 0: return "face.dashed"
        case 1: return "face.smiling"
        case 2: return "face.smiling.fill"
        case 3: return "star.fill"
        default: return "face.smiling"
        }
    }

    private func moodLabel(for value: Int) -> String {
        switch value {
        case 0: return "Awful"
        case 1: return "Meh"
        case 2: return "Good"
        case 3: return "Great"
        default: return ""
        }
    }
}

struct AnxietyQuestionView: View {
    @Binding var score: Int?
    let onSelection: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("Do you feel anxious right now?")
                .font(.title2)
                .bold()

            HStack(spacing: 12) {
                ForEach(0...3, id: \.self) { value in
                    MoodButton(
                        icon: anxietyIcon(for: value),
                        label: anxietyLabel(for: value),
                        isSelected: score == value
                    ) {
                        score = value
                        onSelection()
                    }
                }
            }
        }
        .padding()
    }

    private func anxietyIcon(for value: Int) -> String {
        switch value {
        case 3: return "sun.max"
        case 2: return "cloud.sun"
        case 1: return "cloud.drizzle"
        case 0: return "cloud.heavyrain"
        default: return "cloud"
        }
    }

    private func anxietyLabel(for value: Int) -> String {
        switch value {
        case 3: return "Not at All"
        case 2: return "Slightly"
        case 1: return "Quite"
        case 0: return "Extremely"
        default: return ""
        }
    }
}

struct MotivationQuestionView: View {
    @Binding var score: Int?
    let onSelection: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("How motivated do you feel right now?")
                .font(.title2)
                .bold()

            HStack(spacing: 12) {
                ForEach(0...3, id: \.self) { value in
                    MoodButton(
                        icon: motivationIcon(for: value),
                        label: motivationLabel(for: value),
                        isSelected: score == value
                    ) {
                        score = value
                        onSelection()
                    }
                }
            }
        }
        .padding()
    }

    private func motivationIcon(for value: Int) -> String {
        switch value {
        case 0: return "battery.0"
        case 1: return "battery.25"
        case 2: return "battery.75"
        case 3: return "battery.100"
        default: return "battery.50"
        }
    }

    private func motivationLabel(for value: Int) -> String {
        switch value {
        case 0: return "Not at All"
        case 1: return "Slightly"
        case 2: return "Quite"
        case 3: return "Highly"
        default: return ""
        }
    }
}

// MARK: - Final Summary View
struct SummaryView: View {
    let completeDescription: String
    let completeButtonText: String
    let onComplete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Thanks for sharing!")
                .font(.title2)
                .bold()

            Text(completeDescription)
                .foregroundColor(.secondary)

            Button(action: onComplete) {
                Text(completeButtonText)
                    .frame(maxWidth: .infinity)

            }.buttonStyle(.jAccent)
        }
        .padding()
    }
}

// MARK: - Main View
struct SessionQuestionnaire: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PreSessionViewModel

    let completeDescription: String
    let completeButtonText: String
    let onSessionStart: (_ scores: SessionScores) async -> Void

    init(
        completeDescription: String, completeButtonText: String,
        onSessionStart: @escaping (_ scores: SessionScores) async -> Void
    ) {
        self.completeDescription = completeDescription
        self.completeButtonText = completeButtonText
        self.onSessionStart = onSessionStart
        self.viewModel = PreSessionViewModel(onSessionStart: onSessionStart)
    }

    var body: some View {
        NavigationView {
            TabView(selection: $viewModel.currentStep) {
                FeelingQuestionView(
                    score: $viewModel.scores.feelingScore,
                    onSelection: viewModel.advanceToNextStep
                )
                .tag(0)
                .padding(.bottom)

                AnxietyQuestionView(
                    score: $viewModel.scores.anxietyScore,
                    onSelection: viewModel.advanceToNextStep
                )
                .tag(1)
                .padding(.bottom)

                MotivationQuestionView(
                    score: $viewModel.scores.motivationScore,
                    onSelection: viewModel.advanceToNextStep
                )
                .tag(2)
                .padding(.bottom)

                SummaryView(
                    completeDescription: self.completeDescription,
                    completeButtonText: self.completeButtonText,
                    onComplete: {
                        Task {
                            await viewModel.startSession()
                        }
                    }
                )
                .tag(3)
                .padding(.bottom)

            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

// MARK: - Preview
#Preview {
    SessionQuestionnaire(
        completeDescription: "Let's get this party started",
        completeButtonText: "Start Session"
    ) { scores in
        print("staring \(scores)")
    }
}
