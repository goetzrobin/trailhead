//
//  PersonalityOnboardingBeLikeYouView.swift
//  trailhead
//
//  Created by Robin Götz on 1/20/25.
//

import SwiftUI

struct PersonalityOnboardingBeLikeYouView: View {
    @Environment(NavigationService.self) private var nav
    @Environment(PersonalityOnboardingStore.self) private var store

    @State var showingPromptUpdateModalForIndex: Int? = nil

    let onBack: () -> Void
    let onSkip: () -> Void
    let onContinue: () -> Void

    var body: some View {
        PersonalityOnboardingWrapper(
            onBack: { self.onBack() }, onSkip: { self.onSkip() }
        ) {
            VStack(alignment: .leading) {
                Text("What is it like to be you?")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)
                Text("No need to impress - just be real!")
                    .padding(.bottom, 30)
                VStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { index in
                        ZStack {
                            SelectPromptButtonView {
                                self.store.setCurrentlyRespondingToIndex(
                                    index)
                                self.nav.path.append(
                                    AppNavigationPath.onBoarding(
                                        .personalityOnboarding(
                                            .beLikeYou(.selectPrompt))))
                            }
                            .opacity(
                                self.store.promptResponses[index]?.response
                                    == nil ? 1 : 0)
                            Button(
                                action: {
                                    self.showingPromptUpdateModalForIndex =
                                        index
                                },
                                label: {
                                    VStack {
                                        Text(
                                            self.store.promptResponses[index]?
                                                .option?.prompt ?? "No prompt")
                                        Text(
                                            self.store.promptResponses[index]?
                                                .response ?? "No response")
                                    }
                                }
                            )
                            .buttonStyle(.plain)
                            .opacity(
                                self.store.promptResponses[index]?.response
                                    == nil ? 0 : 1)

                        }
                    }
                }
                Spacer()
                HStack(alignment: .center) {
                    Text(
                        "\(self.store.selectedMentorQualities.count)/\(self.store.maxSelectableMentorQualities) added"
                    )
                    Spacer()
                    Button(action: { self.onContinue() }) {
                        Label(
                            "Confirm collection and continue to next step",
                            systemImage: "chevron.right"
                        )
                        .font(.system(size: 25))
                        .labelStyle(.iconOnly)
                        .padding(5)
                    }.buttonStyle(.borderedProminent)
                        .disabled(
                            self.store.selectedMentorQualities.isEmpty)
                }
            }
            .sheet(
                isPresented: Binding(
                    get: { return showingPromptUpdateModalForIndex != nil },
                    set: { _ in self.showingPromptUpdateModalForIndex = nil })
            ) {
                Button("Update") {
                    if let index = self.showingPromptUpdateModalForIndex,
                        let option = self.store.promptResponses[index]?.option,
                        let response = self.store.promptResponses[index]?
                            .response
                    {
                        self.store.setCurrentlyRespondingToIndex(index)
                        self.store.createNewPromptResponseDraft(
                            option, response: response)
                        self.nav.path.append(
                            AppNavigationPath.onBoarding(
                                .personalityOnboarding(
                                    .beLikeYou(.enterPromptResponse))))
                        self.showingPromptUpdateModalForIndex = nil
                    }
                }
                Button("Replace") {
                    if let index = self.showingPromptUpdateModalForIndex {
                        self.store.setCurrentlyRespondingToIndex(index)
                        self.nav.path.append(
                            AppNavigationPath.onBoarding(
                                .personalityOnboarding(
                                    .beLikeYou(.selectPrompt))))
                        self.showingPromptUpdateModalForIndex = nil
                    }
                }
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
            }

            .navigationDestination(for: AppNavigationPath.self) { path in
                switch path {
                case AppNavigationPath.onBoarding(
                    .personalityOnboarding(.beLikeYou(.selectPrompt))):
                    PromptSelectionView(
                        onSelectOption: {
                            promptOption in
                            self.store.createNewPromptResponseDraft(
                                promptOption)
                            self.nav.path.append(
                                AppNavigationPath.onBoarding(
                                    .personalityOnboarding(
                                        .beLikeYou(.enterPromptResponse))))
                        },
                        onClose: {
                            self.nav.path.removeLast()
                        })
                case AppNavigationPath.onBoarding(
                    .personalityOnboarding(.beLikeYou(.enterPromptResponse))):
                    EnterPromptResponseView(
                        prompt: self.store.currentPromptResponseDraft?.option?
                            .prompt
                            ?? "",
                        response: self.store.currentPromptResponseDraftBinding
                            ?? Binding(projectedValue: .constant("")),
                        maxCharsAllowed: self.store.maxCharsAllowed,
                        onCancel: {
                            self.store.discardCurrentPromptResponseDraft()
                            self.nav.path.removeLast()
                        },
                        onDone: {
                            self.store.commitCurrentPromptResponseDraft()
                            self.nav.path.removeLast(min(self.nav.path.count, 2))
                        }
                    )
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    let nav = NavigationService()
    NavigationStack(
        path: Binding(
            get: { nav.path },
            set: { nav.path = $0 }
        )
    ) {
        PersonalityOnboardingBeLikeYouView(
            onBack: { print("back") }, onSkip: { print("skip") },
            onContinue: { print("continue") }
        )
    }
    .environment(nav)
    .environment(PersonalityOnboardingStore())
}
