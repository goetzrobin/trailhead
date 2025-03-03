//
//  UserAthleticBackgroundView.swift
//  trailhead
//
//  Created by Robin Götz on 2/27/25.
////
//  UserOnboardingCompetitionLevelView.swift
//  trailhead
//
//  Created by Robin Götz on 2/27/25.
//
import SwiftUI

struct UserOnboardingCompetitionLevelView: View {
    @Environment(UserOnboardingStore.self) private var store
    @State private var selectedCompetitionLevel: OnboardingOption?
    @State private var selectedDivision: OnboardingOption?
    @State private var otherDivisionValue: String = ""
    @State private var showDivisionSheet = false

    // Competition level options
    private let competitionLevelOptions: [OnboardingOption] = COMP_LEVEL_OPTIONS

    // Division options
    private let divisionOptions: [OnboardingOption] = DIVISION_OPTIONS

    private let onBack: () -> Void
    private let onContinue: () -> Void

    private var isContinueDisabled: Bool {
        if selectedCompetitionLevel == nil {
            return true
        }

        // If college is selected, require division selection
        if selectedCompetitionLevel?.value == "college" {
            if selectedDivision == nil {
                return true
            }

            if selectedDivision?.type == "custom" && otherDivisionValue.isEmpty
            {
                return true
            }
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
            title:
                "What is the highest level of sport competition you participate(d) in?",
            subtitle: "This helps us understand your athletic background.",
            isContinueDisabled: isContinueDisabled
        ) {
            VStack(spacing: 24) {
                ForEach(competitionLevelOptions) { option in
                    Toggle(
                        isOn: Binding(
                            get: { selectedCompetitionLevel == option },
                            set: {
                                if $0 {
                                    selectedCompetitionLevel = option

                                    // Show division sheet if college is selected
                                    if option.value == "college" {
                                        showDivisionSheet = true
                                    }
                                }
                            }
                        )
                    ) {
                        Text(option.label)
                            .frame(
                                maxWidth: .infinity, minHeight: 50,
                                alignment: .leading
                            )
                            .multilineTextAlignment(.leading)
                    }
                    .toggleStyle(
                        JournaiToggleStyle(
                            fontSize: 18, horizontalPadding: 18,
                            verticalPadding: 8))
                }

                // If college is selected, show a summary of the division selection
                if selectedCompetitionLevel?.value == "college"
                    && selectedDivision != nil
                {
                    HStack {
                        Text("Division:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(
                            selectedDivision?.type == "custom"
                                ? otherDivisionValue
                                : selectedDivision?.label ?? ""
                        )
                        .font(.subheadline)
                        .bold()
                        Button(action: {
                            showDivisionSheet = true
                        }) {
                            Image(systemName: "pencil")
                                .font(.subheadline)
                                .foregroundStyle(Color.jAccent)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(18)
                    .transition(.opacity)
                    .animation(.spring, value: selectedDivision != nil)
                }
            }
            .frame(maxWidth: .infinity)
        } onBack: {
            self.onBack()
        } onContinue: {
            self.onContinue()
        }
        .sheet(isPresented: $showDivisionSheet) {
            DivisionSelectionView(
                divisionOptions: divisionOptions,
                selectedDivision: $selectedDivision,
                otherDivisionValue: $otherDivisionValue
            )
        }
        .onAppear {
            if selectedCompetitionLevel == nil,
                let storeCompLevel = self.store.selectedCompetitionLevel
            {
                selectedCompetitionLevel = competitionLevelOptions.first(where: {
                    $0.value == storeCompLevel.value
                })
            }
            
            
            if selectedDivision == nil,
               let storeDivision = self.store.selectedNcaaDivision
            {
                selectedDivision = divisionOptions.first(where: {
                    $0.value == storeDivision.value
                })
                
                if selectedDivision?.type == "custom" {
                    otherDivisionValue = store.customNcaaDivision ?? ""
                }
            }
            
        }
        .onChange(of: selectedCompetitionLevel) { _, newValue in
            self.store.selectedCompetitionLevel = newValue
        }
        .onChange(of: selectedDivision) { _, newValue in
            self.store.selectedNcaaDivision = newValue
        }
        .onChange(of: otherDivisionValue) { _, newValue in
            if selectedDivision?.type == "custom" {
                self.store.customNcaaDivision = newValue
            }
        }
    }
}

// Sheet view for division selection
struct DivisionSelectionView: View {
    let divisionOptions: [OnboardingOption]
    @Binding var selectedDivision: OnboardingOption?
    @Binding var otherDivisionValue: String
    @Environment(\.dismiss) private var dismiss

    private var isDoneDisabled: Bool {
        if selectedDivision == nil {
            return true
        }

        if selectedDivision?.type == "custom" && otherDivisionValue.isEmpty {
            return true
        }

        return false
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text(
                    "If you are/were a student-athlete, what division did you participate in?"
                )
                .font(.title3)
                .bold()
                .padding(.top, 40)

                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(divisionOptions) { option in
                            Toggle(
                                isOn: Binding(
                                    get: { selectedDivision == option },
                                    set: { if $0 { selectedDivision = option } }
                                )
                            ) {
                                Text(option.label)
                                    .frame(
                                        maxWidth: .infinity, minHeight: 50,
                                        alignment: .leading
                                    )
                                    .multilineTextAlignment(.leading)
                            }
                            .toggleStyle(
                                JournaiToggleStyle(
                                    fontSize: 18, horizontalPadding: 18,
                                    verticalPadding: 8))
                        }

                        if selectedDivision?.type == "custom" {
                            TextField(
                                "Please specify", text: $otherDivisionValue
                            )
                            .bold()
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(18)
                            .transition(
                                .move(edge: .bottom).combined(with: .opacity)
                            )
                            .animation(
                                .spring,
                                value: selectedDivision?.type == "custom")
                        }
                        Spacer()
                        Button("Confirm") {
                            dismiss()
                        }
                        .buttonStyle(.jAccent)
                        .disabled(isDoneDisabled)
                    }
                    .padding()
                }
            }
        }
        .presentationDetents([.large])
        .tint(.jAccent)
    }
}

#Preview {
    @Previewable var store = UserOnboardingStore()
    NavigationStack {
        UserOnboardingCompetitionLevelView(
            onBack: {},
            onContinue: {
                print(
                    store.customNcaaDivision, store.selectedNcaaDivision,
                    store.selectedCompetitionLevel)

            }
        ).environment(store)
    }
}
