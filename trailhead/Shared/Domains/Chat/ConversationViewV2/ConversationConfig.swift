//
//  ConversationConfig.swift
//  trailhead
//
//  Created by Robin Götz on 3/11/25.
//
import Foundation

struct ConversationConfig {
    // Required parameters - no optionals here
    let sessionApiClient: SessionAPIClient
    let authProvider: AuthorizationProvider
    let slug: String
    let userId: UUID
    
    // Optional parameters with defaults
    var sessionLogId: UUID? = nil
    var sessionLogStatus: SessionLog.Status? = nil
    var maxSteps: Int? = nil
    var isShowingXButton: Bool = false
    var customEndConversationLabel: String? = nil
    var onSessionEnded: (() -> Void)? = nil
    var isAutoStartingWithoutPreSurvey: Bool = false
    var onNotNow: (() -> Void)? = nil
    var skipOnNotNowPreSurveySheetDismiss: Bool = false
}
