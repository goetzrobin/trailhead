//
//  CidiState.swift
//  trailhead
//
//  Created by Robin Götz on 2/24/25.
//
import Foundation
import Observation
import SwiftUI

/// NavigationItem represents a step in the CIDI journey with associated data
struct NavigationItem: Hashable, Codable {
    var step: CidiStep
    var id = UUID()
    
    static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        return lhs.step == rhs.step && lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(step)
        hasher.combine(id)
    }
}

/// CIDI State model with navigation path as the source of truth
@Observable
class CidiState {
    private let router: AppRouter
    private let cidiApiClient: CidiAPIClient
    private let timing: CidiTiming
    
    /// Dictionary of survey states by type
    var surveyStates: [SurveyType: SurveyState] = [:]
    
    /// Get survey state for a specific type
    func surveyState(for type: SurveyType) -> SurveyState? {
        return surveyStates[type]
    }
    
    var finalData: [String: Any] {
        // Get all survey answers with appropriate prefixes
        let identityAnswers = getAnswersForSurvey(.careerIdentity, "question1")
        let explorationAnswers = getAnswersForSurvey(.careerExploration, "question2")
        let depthAnswers = getAnswersForSurvey(.careerDepth, "question3")
        let commitmentAnswers = getAnswersForSurvey(.careerCommitment, "question5")
        
        // Combine all answers into a single dictionary
        var combinedAnswers: [String: Any] = [:]
        
        // Helper function to merge dictionaries
        func mergeDictionary(_ dict: [String: Any]) {
            for (key, value) in dict {
                combinedAnswers[key] = value
            }
        }
        
        // Merge all answer dictionaries
        mergeDictionary(identityAnswers)
        mergeDictionary(explorationAnswers)
        mergeDictionary(depthAnswers)
        mergeDictionary(commitmentAnswers)
        
        return combinedAnswers
    }
    
    // MARK: - Initialization
    
    init(router: AppRouter, cidiApiClient: CidiAPIClient, timing: CidiTiming) {
        self.router = router
        self.cidiApiClient = cidiApiClient
        self.timing = timing
        setupSurveys()
    }
    
    private func setupSurveys() {
        surveyStates = [
            .careerIdentity: SurveyState(
                survey: SurveyData.careerIdentityConfusionSurvey),
            .careerExploration: SurveyState(
                survey: SurveyData.careerExplorationBreadthSelfSurvey),
            .careerDepth: SurveyState(
                survey: SurveyData.careerExplorationDepthSelfSurvey),
            .careerCommitment: SurveyState(
                survey: SurveyData.careerCommitmentQualitySurvey),
        ]
    }
    
    // MARK: - Navigation Methods
    
    func moveToNextSurvey(surveyType: SurveyType) {
        let targetStep: CidiStep
        
        switch surveyType {
        case .careerIdentity:
            targetStep = .careerExploration
        case .careerExploration:
            targetStep = .careerDepth
        case .careerDepth:
            targetStep = .careerCommitment
        case .careerCommitment:
            targetStep = .completed
        }
        
        // Add the specific survey step to the navigation
        let navItem = (NavigationItem(step: targetStep))
        self.router.path.append(navItem)
    }
    
    /// Move to the next step in the flow
    func moveToNextStep(currentStep: CidiStep) {
        let nextStep: CidiStep
        switch currentStep {
        case .welcome:
            nextStep = .careerIdentity
        case .careerIdentity:
            nextStep = .careerExploration
        case .careerExploration:
            nextStep = .careerDepth
        case .careerDepth:
            nextStep = .careerCommitment
        case .careerCommitment:
            nextStep = .completed
        case .completed:
            nextStep = .submitted
        case .submitted:
            return // Already at the end
        }
        
        // Add the next step to the navigation
        let lastAddedNavItem = (NavigationItem(step: nextStep))
        self.router.path.append(lastAddedNavItem)
    }
    
    /// Move to the previous step in the flow
    func moveToPreviousStep() {
        self.router.path.removeLast()
    }
    
    /// Reset the CIDI flow
    func resetCidi() {
        setupSurveys()
    }
    
    /// Submit CIDI data
    func submitCidi(for userId: UUID?) {
        guard let userId = userId else { return }
        if self.timing == .pre {
            self.cidiApiClient.submitPreCidiSurvey(userId: userId, answers: finalData) { response in
                self.router.path.removeLast(6)
            }
        }
        
        if self.timing == .post {
            self.cidiApiClient.submitPostCidiSurvey(userId: userId, answers: finalData) { response in
                self.router.path.removeLast(6)
            }
        }
    }
    
    /// Handle survey action
    func handleSurveyAction(surveyType: SurveyType, action: SurveyAction) {
        if let surveyState = surveyStates[surveyType] {
            surveyState.dispatch(action)
        }
    }
    
    private func getAnswersForSurvey(_ surveyType: SurveyType, _ prefix: String) -> [String: Any] {
        guard let surveyState = surveyStates[surveyType] else {
            return [:]
        }
        
        // Filter for non-nil answers only
        let answers = surveyState.survey.answers.compactMap { $0 }
        
        // Create a dictionary with prefix + index as key and answer.value as value
        var result: [String: Any] = [:]
        
        for (index, answer) in answers.enumerated() {
            let key = "\(prefix)\(index)"
            result[key] = answer.value
        }
        
        return result
    }
}

// MARK: - CIDI Step Enum
enum CidiStep: String, CaseIterable, Codable, Hashable {
    case welcome = "Welcome"
    case careerIdentity = "Career Identity"
    case careerExploration = "Career Exploration"
    case careerDepth = "Career Depth"
    case careerCommitment = "Career Commitment"
    case completed = "Completed"
    case submitted = "Submitted"
}
