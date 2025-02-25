//
//  Survey.swift
//  trailhead
//
//  Created by Robin Götz on 2/24/25.
//
import Foundation

enum AnswerType: String, Codable {
    case fixed
    case custom
}

enum QuestionType: String, Codable {
    case multipleChoice = "multiple-choice"
    // Add other question types if needed
}

enum ScoreDirection: String, Codable {
    case smallerBetter = "smaller-better"
    case biggerBetter = "bigger-better"
}

struct SurveyPossibleAnswer: Identifiable, Codable, Hashable {
    var id: String { "\(type.rawValue)-\(value)" }
    let type: AnswerType
    let value: Int
    let label: String
}

struct SurveyActualAnswer: Codable, Hashable {
    let type: AnswerType
    let value: Int
    var customValue: String?
}

struct SurveyQuestion: Identifiable, Codable {
    var id: Int { index }
    let index: Int
    let possibleAnswers: [SurveyPossibleAnswer]
    let question: String
    let type: QuestionType
    let direction: ScoreDirection
}

enum SurveyType: String, CaseIterable, Codable {
    case careerIdentity = "career_identity"
    case careerExploration = "career_exploration"
    case careerDepth = "career_depth"
    case careerCommitment = "career_commitment"
}

struct Survey: Codable {
    let type: SurveyType
    let questions: [SurveyQuestion]
    var answers: [SurveyActualAnswer?]
    
    var title: String {
        switch type {
        case .careerIdentity:
            return "Finding Clarity"
        case .careerExploration:
            return "Exploring Options"
        case .careerDepth:
            return "Going Deeper"
        case .careerCommitment:
            return "Your Priorities"
        }
    }

    var description: String {
        switch type {
        case .careerIdentity:
            return "Share how you feel about finding your direction after sports."
        case .careerExploration:
            return "Tell us how you think about different career possibilities that match who you are."
        case .careerDepth:
            return "Reflect on how well your preferred career path aligns with your strengths."
        case .careerCommitment:
            return "Share how you feel about your current career interests and goals."
        }
    }
    
    // Utility to create a survey with empty answers
    static func createWithEmptyAnswers(type: SurveyType, questions: [SurveyQuestion]) -> Survey {
        return Survey(
            type: type,
            questions: questions,
            answers: Array(repeating: nil, count: questions.count)
        )
    }
    
    // Utility to create a survey with default answers (all set to neutral - 3)
    static func createWithDefaultAnswers(type: SurveyType, questions: [SurveyQuestion]) -> Survey {
        return Survey(
            type: type,
            questions: questions,
            answers: Array(repeating: SurveyActualAnswer(type: .fixed, value: 3, customValue: nil), count: questions.count)
        )
    }
}

