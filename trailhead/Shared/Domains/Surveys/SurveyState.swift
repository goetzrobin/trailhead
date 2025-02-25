//
//  SurveyState.swift
//  trailhead
//
//  Created by Robin Götz on 2/24/25.
//
import Foundation
import Combine
import Observation

// MARK: - Survey Action Types

/// Actions that can be dispatched to modify survey state
enum SurveyAction {
    case reset
    case answerQuestion(forIndex: Int, value: Int)
    case answerCustomQuestion(forIndex: Int, customValue: String)
}

// MARK: - Survey State

@Observable
class SurveyState {
    // State
    var survey: Survey
    
    init(survey: Survey) {
        self.survey = survey
    }
    
    // MARK: - Action Dispatcher
    func dispatch(_ action: SurveyAction) {
        switch action {
        case .reset:
            reset()
        case .answerQuestion(let forIndex, let value):
            answerQuestion(forIndex: forIndex, value: value)
        case .answerCustomQuestion(let forIndex, let customValue):
            answerCustomQuestion(forIndex: forIndex, customValue: customValue)
        }
    }
    
    // MARK: - Action Handlers
    private func reset() {
        survey.answers = Array(repeating: nil, count: survey.questions.count)
    }

    
    private func answerQuestion(forIndex: Int, value: Int) {
        var newAnswers = survey.answers
        newAnswers[forIndex] = SurveyActualAnswer(
            type: .fixed,
            value: value,
            customValue: nil
        )
        survey.answers = newAnswers
    }
    
    private func answerCustomQuestion(forIndex: Int, customValue: String) {
        var newAnswers = survey.answers
        newAnswers[forIndex] = SurveyActualAnswer(
            type: .custom,
            value: 0, // Not applicable for custom type
            customValue: customValue
        )
        survey.answers = newAnswers
    }
}
