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
    
    @State var currentEditingIndex: Int? = nil

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
                Text(
                    "Share a bit about yourself to help us understand you better."
                )
                .padding(.bottom, 30)
                    
                // Add list of prompts here
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(
                            0..<store.promptResponses.count,
                            id: \.self
                        ) { index in
                            let prompt = store.promptResponses[index]
                                
                            Button(action: {
                                store.startEditing(at: index)
                                currentEditingIndex = index
                                router.path
                                    .append(BeLikeYouPath.enterPromptResponse)
                            }) {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(prompt.option.prompt)
                                            .foregroundStyle(.foreground)
                                            .font(.headline)
                                            .multilineTextAlignment(.leading)
                                            
                                        if let response = prompt.response, !response.isEmpty {
                                            Text(response)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .lineLimit(8)
                                        } else {
                                            Text(
                                                "Tap to share your thoughts..."
                                            )
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .padding(.bottom, 40)
                                        }
                                    }
                                        
                                    Spacer()
                                        
                                    Text(prompt.isEmpty ? "Add" : "Edit")
                                        .foregroundColor(.blue)
                                        .bold()
                                }
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(8)
                            }.buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 20)
                }
              
                Spacer()

                HStack(alignment: .center) {
                    Text(
                        "\(store.completedResponsesCount)/\(store.promptResponses.count) added"
                    )
                    Spacer()
                    ContinueButton(
                        label: "Confirm collection and continue to next",
                        isLoading: isLoading
                    ) {
                        self.onContinue()
                    }
                    .disabled(
                        store.completedResponsesCount < store.promptResponses.count || isLoading
                    )
                }
            }
            .navigationDestination(for: BeLikeYouPath.self) { path in
                switch path {
                case .enterPromptResponse:
                    EnterPromptResponseView(
                        prompt: store.currentPrompt,
                        response: store.responseTextBinding ?? Binding
                            .constant(""),
                        maxCharsAllowed: store.maxCharsAllowed,
                        onCancel: {
                            store.cancelEditing()
                            router.path.removeLast()
                        },
                        onDone: {
                            store.finishEditing()
                            router.path.removeLast(min(router.path.count,1))
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var appRouter = AppRouter()
    @Previewable @State var personalityStore = PersonalityOnboardingBeLikeYouStore()
    NavigationStack(path: $appRouter.path) {
        PersonalityOnboardingBeLikeYouView(
            currentStepProgress: 0.5,
            isLoading: false,
            onBack: { print("back") },
            onContinue: { print("continue") }
        )
        .environment(personalityStore)
        .environment(appRouter)
    }
}
