//
//  PersonalityOnboardingFlowView.swift
//  trailhead
//
//  Created by Robin Götz on 1/24/25.
//

import SwiftUI

struct PersonalityOnboardingFlowView: View {
    let router: AppRouter
    let userApiClient: UserAPIClient
    let userID: UUID?
    let isStudentAthlete: Bool
    let onFlowComplete: () -> Void

    @State var progressStore = PersonalityOnboardingProgressStore()
    @State var excitedAboutStore = PersonalityOnboardingExcitedAboutStore()
    @State var mentorTraitsStore = PersonalityOnboardingMentorTraitsStore()
    @State var beLikeYouStore: PersonalityOnboardingBeLikeYouStore
    
    init(router: AppRouter, userApiClient: UserAPIClient, userID: UUID?, isStudentAthlete: Bool, onFlowComplete: @escaping () -> Void) {
        self.router = router
        self.userApiClient = userApiClient
        self.userID = userID
        self.isStudentAthlete = isStudentAthlete
        self.onFlowComplete = onFlowComplete
        
        self.beLikeYouStore = PersonalityOnboardingBeLikeYouStore(isStudentAthlete: self.isStudentAthlete)
    }

    var body: some View {
        PersonalityOnboardingIntroView {
            self.progressStore.updateCurrentPath(
                .excitedAbout)
            self.router.path.append(
                PersonalityPath
                    .excitedAbout)
        }
        .navigationBarBackButtonHidden()

        .navigationDestination(
            for: PersonalityPath.self
        ) {
            path in
            switch path {
            case .excitedAbout:
                PersonalityOnboardingExcitedAboutView(
                    currentStepProgress: self.progressStore.currentStepProgress,
                    onBack: {
                        self.progressStore.updateCurrentPath(
                            .excitedAbout)
                        self.router.path.removeLast()
                    },
                    onSkip: {
                        self.progressStore.updateCurrentPath(
                            .mentorQualities)
                        self.router.path.append(
                            PersonalityPath
                                .mentorQualities)
                    },
                    onContinue: {
                        self.progressStore.updateCurrentPath(
                            .mentorQualities)
                        self.router.path.append(
                            PersonalityPath
                                .mentorQualities)
                    }
                )
                .environment(self.router)
                .environment(self.excitedAboutStore)

            case .mentorQualities:
                PersonalityOnboardingMentorQualitiesView(
                    store: mentorTraitsStore,
                    currentStepProgress: self.progressStore.currentStepProgress,
                    onBack: {
                        self.progressStore.updateCurrentPath(
                            .excitedAbout)
                        self.router.path.removeLast()
                    },
                    onSkip: {
                        self.progressStore.updateCurrentPath(
                            .beLikeYou)
                        self.router.path.append(
                            PersonalityPath
                                .beLikeYou)
                    },
                    onContinue: {
                        self.progressStore.updateCurrentPath(
                            .beLikeYou)
                        self.router.path.append(
                            PersonalityPath
                                .beLikeYou)
                    }
                )
                .environment(self.router)
            case .beLikeYou:
                PersonalityOnboardingBeLikeYouView(
                    currentStepProgress: self.progressStore.currentStepProgress,
                    isLoading: self.userApiClient.updatePersonalityStatus == .loading,
                    onBack: {
                        self.progressStore.updateCurrentPath(
                            .mentorQualities)
                        self.router.path.removeLast()
                    },
                    onContinue: {
                        if let userId = self.userID {
                            userApiClient
                                .updatePersonality(for: userId, with: PersonalityDataRequest(
                                    promptResponses:
                                        beLikeYouStore.promptResponses
                                        .map {prompt in return
                                            PersonalityDataRequest
                                                .PromptResponse(
                                                    promptId: prompt.option.id,
                                                    content: prompt.response ?? "")
                                        },
                                    mentorTraits:
                                        mentorTraitsStore.selectedMentorTraits
                                        .map{ return $0.name },
                                    interests: excitedAboutStore.selectedInterests
                                        .map { return $0.name} )) { _ in
                                            self.onFlowComplete()
                                        }
                        }
                    }
                )
                .environment(self.router)
                .environment(self.beLikeYouStore)
            }
        }
    }
}

#Preview {
    @Bindable var router = AppRouter()
    NavigationStack(path: $router.path) {
        PersonalityOnboardingFlowView(router: router, userApiClient: UserAPIClient(authProvider: AuthStore()), userID: UUID(), isStudentAthlete: false) {
            print("Completed flow")
        }
    }
}
