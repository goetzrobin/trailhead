//
//  PersonalityOnboardingBeLikeYouView.swift
//  trailhead
//
//  Created by Robin Götz on 1/20/25.
//

import SwiftUI

struct PersonalityOnboardingBeLikeYouView: View {
    @Environment(AppRouter.self) private var router
    @Environment(PersonalityOnboardingBeLikeYouStore.self) private var store

    let currentStepProgress: CGFloat
    let isLoading: Bool
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        PersonalityOnboardingWrapper(
            progress: currentStepProgress,
            onBack: { self.onBack() }
        ) {
            VStack(alignment: .leading) {
                Text("What is it like to be you?")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)
                Text("No need to impress - just be real!")
                    .padding(.bottom, 30)

                PromptListView(
                    promptAndResponses: store.promptResponses,
                    onChooseNewPrompt: { index in
                        store.startNewResponse(at: index)
                        router.path.append(BeLikeYouPath.selectPrompt)
                    },
                    onUpdatePrompt: { index in
                        store.startUpdatingResponse(at: index)
                        router.path.append(BeLikeYouPath.enterPromptResponse)
                    })

                Spacer()

                HStack(alignment: .center) {
                    Text(
                        "\(store.respondedToResponsesCount)/\(store.promptResponses.count) added"
                    )
                    Spacer()
                    ContinueButton(
                        label: "Confirm collection and continue to next",
                        isLoading: isLoading
                    ) {
                        self.onContinue()
                    }
                    .disabled(store.respondedToResponsesCount == 0 || isLoading)
                }
            }
            .navigationDestination(for: BeLikeYouPath.self) { path in
                switch path {
                case .selectPrompt:
                    PromptSelectionView(
                        recordedPromptResponses: store.promptResponses,
                        onSelectOption: { promptOption in
                            store.selectPrompt(promptOption)
                            router.path.append(
                                BeLikeYouPath.enterPromptResponse)
                        },
                        onClose: {
                            store.discardDraft()
                            router.path.removeLast()
                        })

                case .enterPromptResponse:
                    EnterPromptResponseView(
                        prompt: store.currentDraft?.option?.prompt ?? "",
                        response: store.currentResponseDraftBinding
                            ?? Binding(projectedValue: .constant("")),
                        maxCharsAllowed: store.maxCharsAllowed,
                        onCancel: {
                            router.path.removeLast()
                        },
                        onDone: {
                            let popCount =
                                store.isUpdatingExistingResponse ? 1 : 2
                            // get count first because comitting will reset it
                            store.commitCurrentDraft()

                            router.path.removeLast(
                                min(router.path.count, popCount))
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var appRouter = AppRouter()
    NavigationStack(path: $appRouter.path) {
        PersonalityOnboardingBeLikeYouView(
            currentStepProgress: 0.5,
            isLoading: false,
            onBack: { print("back") },
            onContinue: { print("continue") }
        )
        .environment(PersonalityOnboardingBeLikeYouStore())
        .environment(appRouter)
    }
}
