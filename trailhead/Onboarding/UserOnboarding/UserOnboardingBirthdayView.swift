//
//  UserOnboardingPronounsView.swift
//  trailhead
//
//  Created by Robin Götz on 1/16/25.
//

import SwiftUI

struct UserOnboardingBirthdayView: View {
    @Environment(UserOnboardingStore.self) private var store
    @State private var isNoBirthdayEntered = false
    @State private var showingSheet = false

    private let onBack: () -> Void
    private let onContinue: () -> Void
    private let onSkip: (() -> Void)?

    init(
        onBack: @escaping () -> Void,
        onSkip: (() -> Void)? = nil,
        onContinue: @escaping () -> Void
    ) {
        self.onBack = onBack
        self.onSkip = onSkip
        self.onContinue = onContinue
    }

    var body: some View {
        @Bindable var store = self.store
        UserOnboardingWrapperView(
            title: "When were you born?",
            subtitle:
                "Sam may surprise you with a birthday gift.",
            isContinueDisabled: !self.isNoBirthdayEntered
        ) {
            DatePicker(
                      "Pick the day you were born",
                      selection: $store.birthday,
                      displayedComponents: [.date])
                      .padding()
                      .labelsHidden()
                      .datePickerStyle(.wheel)
                      .onChange(of: store.birthday) { _,_ in
                          isNoBirthdayEntered = true
                      }
        } onBack: {
            self.onBack()
        } onContinue: {
            self.showingSheet = true
        } onSkip: {
            self.onSkip?()
        }
        .sheet(isPresented: self.$showingSheet) {
            VStack {
                Image(systemName: "birthday.cake")
                    .font(.system(size: 30))
                    .padding()
                    .background(.black)
                    .cornerRadius(20)
                Text("Are you \(self.store.currentAge) years old?")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 2)
                Text("Just making sure we got that right...")
                    .font(.subheadline)
                    .padding(.bottom, 40)
                Button(action: {
                    self.showingSheet = false
                    self.onContinue()
                }) { Text("Validate")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .padding(.bottom, 2)
                Button(action: {
                    self.showingSheet = false
                }) { Text("Update")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)
            
            }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    UserOnboardingBirthdayView(onBack: {}, onSkip: {}, onContinue: {})
        .environment(
            UserOnboardingStore())
}
