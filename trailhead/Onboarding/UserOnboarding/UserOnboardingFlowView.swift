//
//  UserOnboardingFlowView.swift
//  trailhead
//
//  Created by Robin Götz on 1/24/25.
//
import SwiftUI

struct UserOnboardingFlowView: View {
    let router: AppRouter
    let userApiClient: UserAPIClient
    let userId: UUID?
    let onFlowComplete: () -> Void

    @State var userOnboardingStore = UserOnboardingStore()

    var body: some View {
        UserOnboardingNameView(
            onBack: {
                self.router.path = NavigationPath()
            },
            onContinue: {
                self.router.path.append(
                    UserOnboardingPath
                        .pronouns)
            }
        )
        .environment(self.userOnboardingStore)
        .navigationDestination(
            for: UserOnboardingPath.self
        ) {
            path in
            switch path {
            case .pronouns:
                UserOnboardingPronounsView(
                    onBack: { self.router.path.removeLast() },
                    onSkip: {
                        self.router.path.append(
                            UserOnboardingPath
                                .birthday)
                    },
                    onContinue: {
                        self.router.path.append(
                            UserOnboardingPath
                                .birthday)
                    }
                )
                .environment(self.userOnboardingStore)
            case .birthday:
                UserOnboardingBirthdayView(
                    onBack: { self.router.path.removeLast() },
                    onSkip: {
                        self.router.path.append(
                            UserOnboardingPath
                                .ethnicity)
                    },
                    onContinue: {
                        self.router.path.append(
                            UserOnboardingPath
                                .ethnicity)
                    }
                )
                .environment(self.userOnboardingStore)
            case .ethnicity:
                UserOnboardingEthnicitySelectionView(
                    onBack: { self.router.path.removeLast() },
                    onContinue: {
                        self.router.path.append(
                            UserOnboardingPath
                                .genderIdentity)
                    }
                )
                .environment(self.userOnboardingStore)
            case .genderIdentity:
                UserOnboardingGenderIdentityView(
                    onBack: { self.router.path.removeLast() },
                    onContinue: {
                        self.router.path.append(
                            UserOnboardingPath
                                .gradYear)
                    }
                )
                .environment(self.userOnboardingStore)
            case .gradYear:
                UserOnboardingGraduationYearView(
                    onBack: { self.router.path.removeLast() },
                    onContinue: {
                        self.router.path.append(
                            UserOnboardingPath
                                .cohort)
                    }
                )
                .environment(self.userOnboardingStore)
            case .cohort:
                UserOnboardingCohortView(
                    onBack: { self.router.path.removeLast() },
                    onContinue: {
                        self.router.path.append(
                            UserOnboardingPath
                                .competitionLevel)
                    }
                )
                .environment(self.userOnboardingStore)
            case .competitionLevel:
                UserOnboardingCompetitionLevelView(
                    onBack: { self.router.path.removeLast() },
                    onContinue: {
                        self.router.path.append(
                            UserOnboardingPath
                                .submittingInfo)
                    }
                )
                .environment(self.userOnboardingStore)
            case .submittingInfo:
                UserOnboardingSubmittingInfoView(
                    userApiClient: self.userApiClient,
                    userId: self.userId,
                    data: self.userOnboardingStore.data
                ) {
                    self.onFlowComplete()
                    print("completed")
                }.navigationBarBackButtonHidden()
            }
        }
    }
}
#Preview {
    @Previewable @Bindable var router = AppRouter()
    NavigationStack(path: $router.path) {
        UserOnboardingFlowView(router: router, userApiClient: UserAPIClient(authProvider: AuthStore()), userId: UUID()) {
            print("Flow complete")
        }
    }
}
