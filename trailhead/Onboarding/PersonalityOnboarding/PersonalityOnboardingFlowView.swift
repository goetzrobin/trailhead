//
//  PersonalityOnboardingFlowView.swift
//  trailhead
//
//  Created by Robin Götz on 1/24/25.
//

import SwiftUI

struct PersonalityOnboardingFlowView: View {
    let router: AppRouter
    let onFlowComplete: () -> Void

    @State var progressStore = PersonalityOnboardingProgressStore()
    @State var excitedAboutStore = PersonalityOnboardingExcitedAboutStore()
    @State var mentorQualitiesStore =
        PersonalityOnboardingMentorQualitiesStore()
    @State var beLikeYouStore =
        PersonalityOnboardingBeLikeYouStore()

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
                .environment(self.mentorQualitiesStore)
            case .beLikeYou:
                PersonalityOnboardingBeLikeYouView(
                    currentStepProgress: self.progressStore.currentStepProgress,
                    onBack: {
                        self.progressStore.updateCurrentPath(
                            .mentorQualities)
                        self.router.path.removeLast()
                    },
                    onContinue: {
                        self.onFlowComplete()
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
        PersonalityOnboardingFlowView(router: router) {
            print("Completed flow")
        }
    }
}
