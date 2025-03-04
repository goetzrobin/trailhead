//
//  UserOnboardingGroupSelectionView.swift
//  trailhead
//
//  Created by Robin Götz on 2/27/25.
//
import SwiftUI



struct UserOnboardingCohortView: View {
    @Environment(UserOnboardingStore.self) private var store
    @State private var selectedOption: OnboardingOption?
    @State private var otherValue: String = ""
    
    // Group options based on your provided data
    private let groupOptions: [OnboardingOption] = COHORT_OPTIONS
    
    private let onBack: () -> Void
    private let onContinue: () -> Void
    
    private var isContinueDisabled: Bool {
        if selectedOption == nil {
            return true
        }
        
        if selectedOption?.type == "custom" && otherValue.isEmpty {
            return true
        }
        
        return false
    }
    
    init(
        onBack: @escaping () -> Void,
        onContinue: @escaping () -> Void) {
        self.onBack = onBack
        self.onContinue = onContinue
    }
    
    var body: some View {
        @Bindable var store = self.store
        UserOnboardingWrapperView(
            title: "Please select which group you belong",
            subtitle: "This helps us personalize your experience.",
            isContinueDisabled: isContinueDisabled
        ) {
            VStack(spacing: 24) {
                ForEach(groupOptions) { option in
                    Toggle(isOn: Binding(
                        get: { selectedOption == option },
                        set: { if $0 { selectedOption = option } }
                    )) {
                        Text(option.label).frame(maxWidth: .infinity, minHeight: 50, alignment: .leading).multilineTextAlignment(.leading)
                    }
                    .onboardingToggleStyle()
                }
                
                if selectedOption?.type == "custom" {
                    TextField("Please specify", text: $otherValue)
                        .bold()
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(18)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.spring, value: selectedOption?.type == "custom")
                        .tint(.jAccent)
                }
            }
            .frame(maxWidth: .infinity)
        } onBack: {
            self.onBack()
        } onContinue: {
            self.onContinue()
        }
        .onAppear {
            setSelectedCohort()
        }
        .onChange(of: selectedOption) { _, newValue in
            self.store.selectedCohort = newValue
        }
        .onChange(of: otherValue) { _, newValue in
            if (selectedOption?.type == "custom") {
                self.store.customCohort = newValue
            }
        }
    }
    
    private func setSelectedCohort() {
        if selectedOption == nil, let selectedCohort = self.store.selectedCohort {
            print("doing stuff")
            if selectedCohort.type == "custom" {
                otherValue = store.customCohort ?? ""
            }
            else {
                selectedOption = groupOptions.first(where: { $0.value == selectedCohort.value })
                otherValue = ""
                store.customCohort = nil
            }
        }
    }
}

#Preview {
    @Previewable var store = UserOnboardingStore()
    NavigationStack {
        UserOnboardingCohortView(onBack: {}, onContinue: {
            print(store.selectedCohort, store.customCohort)
        }).environment(store)
    }
}
