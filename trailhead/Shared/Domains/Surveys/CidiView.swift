//
//  CidiView.swift
//  trailhead
//
//  Created by Robin Götz on 2/25/25.
//
import SwiftUI

enum CidiTiming {
    case pre
    case post
}
// MARK: - Main CIDI View
struct CidiView: View {
    @Environment(ApplicationViewLayoutService.self) var layoutService:
    ApplicationViewLayoutService
    @State private var cidiState: CidiState
    private let userId: UUID?
    private let router: AppRouter
    private let timing: CidiTiming

    init(
        userId: UUID?,
        cidi: CidiAPIClient,
        router: AppRouter,
        timing: CidiTiming? = nil
    ) {
        self.userId = userId
        self.router = router
        self.timing = timing ?? .pre
        self.cidiState = CidiState(
            router: router,
            cidiApiClient: cidi,
            timing: self.timing)
    }

    var body: some View {
        @Bindable var cidiState = cidiState
        CidiWelcomeView {
            cidiState.moveToNextStep(currentStep: .welcome)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    router.path.removeLast()
                }
                .foregroundStyle(.secondary)
            }
        }
        .onAppear {
            layoutService.hideTabBar(animate: true)
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(for: NavigationItem.self) { item in
            destinationView(for: item.step)
                .navigationTitle(item.step.rawValue)
        }
        .tint(Color.jAccent)
    }

    @ViewBuilder
    private func destinationView(for step: CidiStep) -> some View {
        switch step {
        case .welcome:
            // Welcome is the root, so we shouldn't need this case
            EmptyView()
        case .careerIdentity:
            surveyView(for: .careerIdentity)

        case .careerExploration:
            surveyView(for: .careerExploration)

        case .careerDepth:
            surveyView(for: .careerDepth)

        case .careerCommitment:
            surveyView(for: .careerCommitment)

        case .completed:
            CidiCompletionView(
                isLoading: cidiState.submitCidiStatus == .loading
            ) {
                cidiState.submitCidi(for: userId)
            }
            .navigationTitle("")
            .onAppear {
                self.cidiState.isOnFinalStep = true
            }
            .onDisappear {
                self.cidiState.isOnFinalStep = false
            }

        case .submitted:
            // This is a terminal state
            Text("\(cidiState.finalData)")
                .font(.title)
                .padding()
        }
    }

    private func surveyView(for surveyType: SurveyType) -> some View {
        Group {
            if let surveyState = cidiState.surveyState(for: surveyType) {
                SurveyContainerView(
                    surveyState: surveyState,
                    onBack: {
                        cidiState.moveToPreviousStep()
                    },
                    onComplete: {
                        cidiState.moveToNextSurvey(surveyType: surveyType)
                    }
                )
            } else {
                Text("Loading survey...")
            }
        }
    }
}

// MARK: - Welcome View
struct CidiWelcomeView: View {
    @State var isShowing = false
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "person.fill.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.jAccent)
                .padding()

            Text("Welcome to Your Journey")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(
                "Together, we'll explore how AI mentorship can support student athletes like you in reaching your goals. This will take about 5 minutes."
            )
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.horizontal)

            Spacer()

            Button(action: onContinue) {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.jAccent)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .opacity(isShowing ? 1 : 0)
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + .milliseconds(300)
            ) {
                withAnimation {
                    isShowing = true
                }
            }
        }
    }
}

// MARK: - Completion View
struct CidiCompletionView: View {
    let isLoading: Bool
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.jAccent)
                .padding()

            Text("Thank You")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(
                "Your participation helps us understand how AI can better support student athletes in their development journey."
            )
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.horizontal)

            Spacer()

            Button(action: onFinish) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .frame(width: 23, height: 23)
                            .tint(.black)
                    } else {
                        Text("Continue")
                        .fontWeight(.semibold)                    }
                }.frame(maxWidth: .infinity)
            }
            .buttonStyle(.jSecondary)
            .disabled(isLoading)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
    }
}

// MARK: - CIDI Navigation Container
struct CidiNavigationContainer: View {
    @Environment(AuthStore.self) private var auth: AuthStore
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(CidiAPIClient.self) private var cidi: CidiAPIClient

    let timing: CidiTiming?

    var body: some View {
        CidiView(
            userId: auth.userId,
            cidi: cidi,
            router: router,
            timing: timing
        )
    }
}

#Preview {
    CidiNavigationContainer(timing: nil)
        .environment(AuthStore())
        .environment(AppRouter())
        .environment(ApplicationViewLayoutService())
        .environment(CidiAPIClient(authProvider: AuthStore()))
}
