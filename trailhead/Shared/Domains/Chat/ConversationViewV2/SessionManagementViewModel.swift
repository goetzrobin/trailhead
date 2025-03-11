//
//  SessionManagementViewModel.swift
//  trailhead
//
//  Created by Robin Götz on 3/11/25.
//
import Foundation
import Observation
import SwiftUI

@Observable class SessionManagementViewModel {
    // Dependencies
    private let sessionAPIClient: SessionAPIClient
    
    // Required properties
    private let slug: String
    private let userId: UUID
    private let onSessionEnded: (() -> Void)?
    
    // State
    private(set) var sessionLogId: UUID?
    private(set) var sessionLogStatus: SessionLog.Status = .inProgress
    
    private(set) var isShowingPreSurvey = false
    private(set) var isSessionStartLoading = false
    
    private(set) var isShowingPostSurvey = false
    private(set) var isSessionEndLoading = false
    

    
    init(
        sessionAPIClient: SessionAPIClient,
        slug: String,
        userId: UUID,
        sessionLogId: UUID?,
        sessionLogStatus: SessionLog.Status = .inProgress,
        onSessionEnded: (() -> Void)?
    ) {
        self.sessionAPIClient = sessionAPIClient
        self.slug = slug
        self.userId = userId
        self.sessionLogId = sessionLogId
        self.sessionLogStatus = sessionLogStatus
        self.onSessionEnded = onSessionEnded
    }
    
    func showPreSurvey() {
        self.isShowingPreSurvey = true
    }
    
    func handlePreSurveySubmission(
        feeling: Int,
        anxiety: Int,
        motivation: Int
    ) {
        print(
            "[ConversationView2] submitting pre survey mood \(feeling) - anxiety \(anxiety) - motivation \(motivation)"
        )
        withAnimation {
            self.isSessionStartLoading = true
        }
        self.sessionAPIClient
            .startSession(
                with: self.slug,
                for: self.userId,
                scores: SessionScores(
                    feelingScore: feeling,
                    anxietyScore: anxiety,
                    motivationScore: motivation
                )
            ) { newLog in
                print(
                    "[ConversationView2] submitted pre survey and successfully started session and got log with id \(newLog.id)"
                )
                self.sessionLogId = newLog.id
                self.sessionLogStatus = newLog.status
                withAnimation {
                    self.isSessionStartLoading = false
                    self.isShowingPreSurvey = false
                }
                
            }
    }
    
    func handlePostSurveySubmission(feeling: Int, anxiety: Int, motivation: Int) {
        guard let sessionLogId = self.sessionLogId else {
            print("No session log id for \(self.slug) - cannot submit post survey")
            return
        }
        print("[ConversationView2] submitting post survey mood \(feeling) - anxiety \(anxiety) - motivation \(motivation)")
        withAnimation {
            self.isSessionEndLoading = true
        }
        self.sessionAPIClient
            .endSession(
                ofLogWithId: sessionLogId,
                scores: SessionScores(
                    feelingScore: feeling,
                    anxietyScore: anxiety,
                    motivationScore: motivation
                )
            ) { newLog in
                print("[ConversationView2] submitted post survey and successfully ended session log \(sessionLogId) for \(self.slug)")
            withAnimation {
                self.isSessionEndLoading = false
                self.isShowingPostSurvey = false
            }
                self.onSessionEnded?()
        }
    }
    
     func handleOnEndConversation() {
        print("[ConversationView2] starting end conversation flow by showing survey")
        self.isShowingPostSurvey = true
    }
}
