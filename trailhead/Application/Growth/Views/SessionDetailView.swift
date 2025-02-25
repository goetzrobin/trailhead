//
//  SessionDetailView.swift
//  trailhead
//
//  Created by Robin Götz on 2/11/25.
//
import SwiftUI

struct SessionDetailView: View {
    @Environment(ApplicationViewLayoutService.self) var layoutService: ApplicationViewLayoutService
    @Environment(AuthStore.self) var authStore: AuthStore
    @Environment(SessionAPIClient.self) var sessionApiClient: SessionAPIClient
    let session: Session
    @State private var isSessionCompleted = false

    var body: some View {
        VStack(spacing: 16) {
            if let slug = session.slug, let userId = authStore.userId {
                ConversationView(
                    sessionApiClient: sessionApiClient,
                    authProvider: authStore,
                    slug: slug,
                    userId: userId,
                    sessionLogId: session.logs?.first?.id, maxSteps: session.stepCount,
                    sessionLogStatus: session.logs?.first?.status
                )
            } else {
                Text("Missing required information about session or user.")
            }
        }
        .navigationTitle(session.name ?? "Unknown session")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            layoutService.hideTabBar(animate: true)
        }
        .onDisappear {
            layoutService.showTabBar(animate: true)
        }
    }
    
    func onSessionStarted() {
        
    }
}

#Preview {
    NavigationStack {
        SessionDetailView(session: try! JSONDecoder().decode(Session.self, from: """
{
        "id": "84220005-eedd-4a5f-8b0f-42676b84deb3",
        "slug": "onboarding-v0",
        "name": "Getting Started",
        "description": "We start with a letter about yourself and who you are!",
        "stepCount": 5,
        "imageUrl": "onboarding-v0.jpg",
        "index": 0,
        "status": "ACTIVE",
        "estimatedCompletionTime": 5,
        "createdAt": "2024-08-16T11:57:01.089Z",
        "updatedAt": null,
        "logs": [
            {
                "id": "65b37581-0aff-4f5d-b408-3ab6894eadfa",
                "userId": "922a56aa-9970-46a3-86d4-123cd43d50e2",
                "sessionId": "84220005-eedd-4a5f-8b0f-42676b84deb3",
                "preFeelingScore": null,
                "preMotivationScore": null,
                "preAnxietyScore": null,
                "postFeelingScore": null,
                "postMotivationScore": null,
                "postAnxietyScore": null,
                "version": 0,
                "summary": "### Summary of Our Conversation\n\nIt was heartwarming to see you open up about your experiences, especially how rereading your letter encouraged you to share even more. Your willingness to be vulnerable is truly commendable, and it sets a solid foundation for our journey together.\n\nI appreciate your understanding of my role as an AI mentor. While I may not experience emotions like you do, I’m here to reflect your thoughts and help you navigate your path. Think of me as a supportive mirror, reflecting your insights and guiding you through the complexities of your feelings and experiences.\n\nYou shared a fascinating insight about yourself: your analytical prowess shines through in your academic achievements, yet you find interpersonal relationships and conflicts to be more challenging. It’s completely understandable—logic problems have clear solutions, while human interactions can feel like a maze!\n\nAs we embark on this four-week exploration, we’ll focus on what excites you and tap into your strengths, taking it step by step. Just like solving a logic puzzle, we’ll break things down into manageable pieces, ensuring you feel comfortable throughout the process.\n\nI’m excited about our next chat and the journey ahead. Remember, I’m here whenever you’re ready to dive deeper. Keep that analytical mind sharp, and let’s tackle this together!",
                "status": "COMPLETED",
                "startedAt": "2024-10-29T12:38:19.908Z",
                "completedAt": "2024-10-29T12:43:44.170Z",
                "createdAt": "2024-10-29T12:38:19.956Z",
                "updatedAt": "2024-10-29T12:43:44.170Z"
            }
        ]
    }
""".data(using: .utf8)!))
    }
    .environment(ApplicationViewLayoutService())
}
