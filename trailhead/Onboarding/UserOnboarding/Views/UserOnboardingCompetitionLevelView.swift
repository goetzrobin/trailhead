import SwiftUI

// MARK: - Main View
struct UserOnboardingCompetitionLevelView: View {
    @Environment(UserOnboardingStore.self) private var store
    @State private var selectedCompetitionLevel: OnboardingOption?
    @State private var selectedDivision: OnboardingOption?
    @State private var otherDivisionValue: String = ""
    @State private var showDivisionSheet = false

    private let competitionLevelOptions = COMP_LEVEL_OPTIONS
    private let divisionOptions = DIVISION_OPTIONS
    private let onBack: () -> Void
    private let onContinue: () -> Void

    private var isContinueDisabled: Bool {
        if selectedCompetitionLevel == nil { return true }
        if selectedCompetitionLevel?.value == "college" {
            if selectedDivision == nil { return true }
            if selectedDivision?.type == "custom" && otherDivisionValue.isEmpty { return true }
        }
        return false
    }

    init(onBack: @escaping () -> Void, onContinue: @escaping () -> Void) {
        self.onBack = onBack
        self.onContinue = onContinue
    }

    var body: some View {
        @Bindable var store = self.store
        
        UserOnboardingWrapperView(
            title: "What is the highest level of sport competition you participate(d) in?",
            subtitle: "This helps us understand your athletic background.",
            isContinueDisabled: isContinueDisabled
        ) {
            competitionLevelSelectionView
            divisionSummaryView
        } onBack: {
            onBack()
        } onContinue: {
            onContinue()
        }
        .sheet(isPresented: $showDivisionSheet) {
            DivisionSelectionView(
                divisionOptions: divisionOptions,
                selectedDivision: $selectedDivision,
                otherDivisionValue: $otherDivisionValue
            )
        }
        .onAppear(perform: loadStoredValues)
        .onChange(of: selectedCompetitionLevel) { _, newValue in
            store.selectedCompetitionLevel = newValue
        }
        .onChange(of: selectedDivision) { _, newValue in
            store.selectedNcaaDivision = newValue
        }
        .onChange(of: otherDivisionValue) { _, newValue in
            if selectedDivision?.type == "custom" {
                store.customNcaaDivision = newValue
            }
        }
    }
    
    // MARK: - Subviews
    private var competitionLevelSelectionView: some View {
        VStack(spacing: 24) {
            ForEach(competitionLevelOptions) { option in
                Toggle(
                    isOn: Binding(
                        get: { selectedCompetitionLevel == option },
                        set: {
                            if $0 {
                                selectedCompetitionLevel = option
                                if option.value == "college" {
                                    showDivisionSheet = true
                                }
                            }
                        }
                    )
                ) {
                    Text(option.label)
                        .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
                .onboardingToggleStyle()

            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var divisionSummaryView: some View {
        Group {
            if selectedCompetitionLevel?.value == "college" && selectedDivision != nil {
                HStack {
                    Text("Division:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(selectedDivision?.type == "custom" ? otherDivisionValue : selectedDivision?.label ?? "")
                        .font(.subheadline)
                        .bold()
                    Button(action: { showDivisionSheet = true }) {
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
    }
    
    // MARK: - Helper Methods
    private func loadStoredValues() {
        if selectedCompetitionLevel == nil, let storeCompLevel = store.selectedCompetitionLevel {
            selectedCompetitionLevel = competitionLevelOptions.first { $0.value == storeCompLevel.value }
        }
        
        if selectedDivision == nil, let storeDivision = store.selectedNcaaDivision {
            selectedDivision = divisionOptions.first { $0.value == storeDivision.value }
            
            if selectedDivision?.type == "custom" {
                otherDivisionValue = store.customNcaaDivision ?? ""
            }
        }
    }
}

// MARK: - Division Selection Sheet
struct DivisionSelectionView: View {
    let divisionOptions: [OnboardingOption]
    @Binding var selectedDivision: OnboardingOption?
    @Binding var otherDivisionValue: String
    @Environment(\.dismiss) private var dismiss

    private var isDoneDisabled: Bool {
        selectedDivision == nil ||
        (selectedDivision?.type == "custom" && otherDivisionValue.isEmpty)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("If you are/were a student-athlete, what division did you participate in?")
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
                                    .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                            }
                            .onboardingToggleStyle()
                        }

                        if selectedDivision?.type == "custom" {
                            TextField("Please specify", text: $otherDivisionValue)
                                .bold()
                                .padding()
                                .background(.thinMaterial)
                                .cornerRadius(18)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .animation(.spring, value: selectedDivision?.type == "custom")
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Confirm").frame(maxWidth: .infinity)
                        })
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

// MARK: - Preview
#Preview {
    @Previewable var store = UserOnboardingStore()
    return NavigationStack {
        UserOnboardingCompetitionLevelView(
            onBack: {},
            onContinue: {
                print(store.customNcaaDivision,
                      store.selectedNcaaDivision,
                      store.selectedCompetitionLevel)
            }
        ).environment(store)
    }
}
