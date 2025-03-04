//
//  UserOnboardingGenderIdentityView.swift
//  trailhead
//
//  Created by Robin Götz on 2/27/25.
//
import SwiftUI

struct GenderIdentityOption: Identifiable, Equatable {
    var id: String { value }
    let type: String // 'fixed' or 'custom'
    let value: String
    let label: String
    
    static func == (lhs: GenderIdentityOption, rhs: GenderIdentityOption) -> Bool {
        return lhs.value == rhs.value
    }
}

struct UserOnboardingGenderIdentityView: View {
    @Environment(UserOnboardingStore.self) private var store
    @State private var selectedOption: OnboardingOption?
    @State private var customValue: String = ""
    
    // Gender identity options based on provided data
    private let genderOptions = GENDER_OPTIONS
    
    private let onBack: () -> Void
    private let onContinue: () -> Void
    
    private var isContinueDisabled: Bool {
        if selectedOption == nil {
            return true
        }
        
        // If a custom option that requires description is selected, ensure it's not empty
        if selectedOption?.type == "custom" && customValue.isEmpty {
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
            title: "What is your gender identity?",
            subtitle: "This helps us understand our community better.",
            isContinueDisabled: isContinueDisabled
        ) {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(genderOptions) { option in
                        VStack(spacing: 12) {
                            Toggle(isOn: Binding(
                                get: { selectedOption == option },
                                set: { if $0 { selectedOption = option } }
                            )) {
                                Text(option.label)
                                    .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                            }
                            .onboardingToggleStyle()
                            
                            // Show text field immediately after the custom option when selected
                            if option.type == "custom" && selectedOption == option {
                                TextField("Please specify", text: $customValue)
                                    .bold()
                                    .padding()
                                    .background(.thinMaterial)
                                    .cornerRadius(18)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .animation(.spring, value: selectedOption == option)
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
            initSelectedGenderIdentity()
        }
        .onChange(of: selectedOption) { _, newValue in
            self.store.selectedGenderIdentity = newValue
        }
        .onChange(of: customValue) { _, newValue in
            if selectedOption?.type == "custom" {
                self.store.customGenderIdentity = newValue
            }
        }
    }

    private func initSelectedGenderIdentity() {
        if selectedOption == nil, let selectedGenderIdentity = self.store.selectedGenderIdentity
        {
            selectedOption = genderOptions.first(where: {
                $0.value == selectedGenderIdentity.value
            })
            
            if selectedGenderIdentity.type == "custom" {
                customValue = store.customGenderIdentity ?? ""
            }
        }
    }
    
}

#Preview {
    @Previewable var store = UserOnboardingStore()
    NavigationStack {
        UserOnboardingGenderIdentityView(onBack: {}, onContinue: {
            print(store.customGenderIdentity, store.selectedGenderIdentity)
        }).environment(store)
    }
}
