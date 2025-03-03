//
//  UserGraduationYearView.swift
//  trailhead
//
//  Created by Robin Götz on 2/26/25.
//
import SwiftUI

struct UserOnboardingGraduationYearView: View {
    @Environment(UserOnboardingStore.self) private var store
    
    // Available years for the picker (2010-2035)
    private let availableYears = Array(2010...2035)
    
    private let onBack: () -> Void
    private let onContinue: () -> Void
    
    init(
        onBack: @escaping () -> Void,
        onContinue: @escaping () -> Void) {
        self.onBack = onBack
        self.onContinue = onContinue
    }

    var body: some View {
        @Bindable var store = self.store
        UserOnboardingWrapperView(
            title: "When do you graduate?",
            subtitle: "Select your graduation year.",
            isContinueDisabled: false
        ) {
            Picker("Graduation Year", selection: $store.graduationYear) {
                ForEach(availableYears, id: \.self) { year in
                    Text(verbatim: "\(year)")
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .clipped() // Ensure picker stays within bounds
        } onBack: {
            self.onBack()
        } onContinue: {
            self.onContinue()
        }
    }
}

#Preview {
    NavigationStack {
        UserOnboardingGraduationYearView(onBack: {}, onContinue: {}).environment(UserOnboardingStore())
    }
}
