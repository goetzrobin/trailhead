//
//  UserOnboardingFlowView.swift
//  trailhead
//
//  Created by Robin Götz on 1/24/25.
//
import SwiftUI

struct UserOnboardingFlowView: View {
    let router: AppRouter
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
                        self.onFlowComplete()
                    },
                    onContinue: {
                        self.onFlowComplete()
                    }
                )
                .environment(self.userOnboardingStore)
            }
        }
    }
}
#Preview {
    UserOnboardingFlowView(router: AppRouter()) {
        print("Flow complete")
    }
}
