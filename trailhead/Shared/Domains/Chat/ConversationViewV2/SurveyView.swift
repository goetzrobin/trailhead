//
//  SurveyView.swift
//  trailhead
//
//  Created by Robin Götz on 3/10/25.
//
import SwiftUI

enum SurveyVariant {
    case pre
    case post
}

struct SurveyView: View {
    private var title: String = ""
    private var subtitle: String = ""
    private var buttonLabel: String = ""
    private var buttonIcon: String = ""
    private var buttonLoadingLabel: String = ""
    
    let variant: SurveyVariant
    let isLoading: Bool
    let onSurveyCompleted: (_: Int, _: Int, _: Int) -> Void
    
    init(
        variant: SurveyVariant,
        isLoading: Bool,
        onSurveyCompleted: @escaping (_: Int, _: Int, _: Int) -> Void
    ) {
        self.variant = variant
        self.isLoading = isLoading
        self.onSurveyCompleted = onSurveyCompleted
        
        if variant == .pre {
            self.title = "Before We Connect"
            self.subtitle = "Help your mentor understand how you're feeling today so they can provide better guidance."
            self.buttonLabel = "Start Conversation"
            self.buttonIcon = "bubble.left.and.bubble.right"
            self.buttonLoadingLabel = "Connecting..."
        } else if variant == .post {
            self.title = "Before You Go"
            self.subtitle = "Share how you're feeling after your mentoring session. This helps us improve and track your progress."
            self.buttonLabel = "Save & Finish"
            self.buttonIcon = "square.and.arrow.down.on.square"
            self.buttonLoadingLabel = "Saving..."
        }
       
    }
    
    @State var feelingScore = 1
    @State var anxietyScore = 1
    @State var motivationScore = 1
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(height: 120)
            .padding(.top, 20)
                        
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading) {
                    Text("How are you feeling right now?")
                        .font(.headline)
                    Picker("Mood", selection: $feelingScore){
                        Text("Awful").tag(0)
                        Text("Meh").tag(1)
                        Text("Good").tag(2)
                        Text("Great").tag(3)
                    }.pickerStyle(.segmented)
                        .disabled(isLoading)
                }
                VStack(alignment: .leading) {
                    Text("Do you feel anxious right now?")
                        .font(.headline)
                    Picker("Anxiety", selection: $anxietyScore){
                        Text("Not at all").tag(0)
                        Text("Slightly").tag(1)
                        Text("Quite").tag(2)
                        Text("Extremely").tag(3)
                    }.pickerStyle(.segmented)
                        .disabled(isLoading)
                    
                }
                VStack(alignment: .leading) {
                    
                    Text("How motivated do you feel right now?")
                        .font(.headline)
                    Picker("Motivation", selection: $motivationScore){
                        Text("Not at all").tag(0)
                        Text("Quite").tag(1)
                        Text("Highly").tag(2)
                        Text("Extremely").tag(3)
                    }.pickerStyle(.segmented)
                        .disabled(isLoading)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 48)
        
        Spacer()

        HStack {
            Spacer()
            Button(
                action: {
                    onSurveyCompleted(self.feelingScore, self.anxietyScore, self.motivationScore)
                },
                label: {
                    HStack {
                        if isLoading {
                            Label(title: {
                                Text(self.buttonLoadingLabel)
                                    .bold()
                                    .font(.system(size: 13))
                                    .frame(height: 18)
                            }, icon: {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .frame(height: 18)
                            })
                        } else {
                            Label(
                                self.buttonLabel,
                                systemImage: self.buttonIcon
                            )
                            .bold()
                            .font(.system(size: 13))
                            .frame(height: 18)
                            .labelStyle(.titleAndIcon)
                        }
                    }
                })
            .cornerRadius(50)
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    
    }
}


struct SurveySheetModifier: ViewModifier {
    let height: CGFloat
    let isDismissable: Bool
    
    init(isDismissable: Bool = false, height: CGFloat = 520) {
        self.isDismissable = isDismissable
        self.height = height
    }
    
    func body(content: Content) -> some View {
        content
            .background(.clear)
            .presentationBackground(.thinMaterial)
            .presentationDetents([.height(height)])
            .interactiveDismissDisabled(!isDismissable)
    }
}

// Extension to make it easier to use
extension View {
    func surveySheet(isDismissable: Bool = false, height: CGFloat = 520) -> some View {
        self.modifier(SurveySheetModifier(isDismissable: isDismissable, height: height))
    }
}
