//
//  UserOnboardingEthnicityView.swift
//  trailhead
//
//  Created by Robin Götz on 2/27/25.
//
import SwiftUI

struct UserOnboardingEthnicitySelectionView: View {
    @Environment(UserOnboardingStore.self) private var store
    @State private var selectedOption: OnboardingOption?
    @State private var customValue: String = ""

    // Ethnicity options based on provided data
    private let ethnicityOptions: [OnboardingOption] = ETHNICITY_OPTIONS

    private let onBack: () -> Void
    private let onContinue: () -> Void

    private var isContinueDisabled: Bool {
        if selectedOption == nil {
            return true
        }

        if selectedOption?.type == "custom" && customValue.isEmpty {
            return true
        }

        return false
    }

    init(
        onBack: @escaping () -> Void,
        onContinue: @escaping () -> Void
    ) {
        self.onBack = onBack
        self.onContinue = onContinue
    }

    var body: some View {
        @Bindable var store = self.store
        UserOnboardingWrapperView(
            title: "What is your race/ethnicity?",
            subtitle:
                "This information helps us ensure diversity in our community.",
            isContinueDisabled: isContinueDisabled
        ) {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(ethnicityOptions) { option in
                        VStack(spacing: 12) {
                            Toggle(
                                isOn: Binding(
                                    get: { selectedOption == option },
                                    set: { if $0 { selectedOption = option } }
                                )
                            ) {
                                Text(option.label)
                                    .frame(
                                        maxWidth: .infinity, minHeight: 50,
                                        alignment: .leading
                                    )
                                    .multilineTextAlignment(.leading)
                            }
                            .onboardingToggleStyle()


                            // Show text field immediately after the custom option when selected
                            if option.type == "custom"
                                && selectedOption == option
                            {
                                TextField("Please specify", text: $customValue)
                                    .bold()
                                    .padding()
                                    .background(.thinMaterial)
                                    .cornerRadius(18)
                                    .transition(
                                        .move(edge: .bottom).combined(
                                            with: .opacity)
                                    )
                                    .animation(
                                        .spring, value: selectedOption == option
                                    )
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        } onBack: {
            self.onBack()
        } onContinue: {
            self.onContinue()
        }
        .onAppear {
            initSelectedEthnicity()
        }
        .onChange(of: selectedOption) { _, newValue in
            self.store.selectedEthnicity = newValue
        }
        .onChange(of: customValue) { _, newValue in
            if selectedOption?.type == "custom" {
                self.store.customEthnicity = newValue
            }
        }
    }

    private func initSelectedEthnicity() {
        if selectedOption == nil, let selectedEthnicity = self.store.selectedEthnicity
        {
            if selectedEthnicity.type == "custom" {
                customValue = store.customEthnicity ?? ""
            } else {
                selectedOption = ethnicityOptions.first(where: {
                    $0.value == selectedEthnicity.value
                })
            }
        }
    }
}

#Preview {
    @Previewable var store = UserOnboardingStore()
    NavigationStack {
        UserOnboardingEthnicitySelectionView(onBack: {}, onContinue: {
            print(store.selectedEthnicity, store.customEthnicity)
        })
            .environment(store)
    }
}
