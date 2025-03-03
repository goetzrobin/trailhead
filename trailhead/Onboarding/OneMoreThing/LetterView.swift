import SwiftUI

fileprivate let prompts: [LocalizedStringKey] = [
    "I'll move to the next question whenever you finish a sentence. Write **Hey Sam!** to get started.",
    "What sport did or do you play for your university?",
    "What achievement are you most proud of?",
    "What's your favorite book, movie or TV show?",
    "What's a goal you are working towards?",
    "What does a typical Sunday look like for you?",
    "Who's someone you are close to?",
    "Do you have any siblings?",
    "What subject did you enjoy most in school?",
    "What's something you've always wanted to try?",
    "What's one thing your friends love about you?",
    "What's an important belief that guides your choices?",
    "What, in life, do you want to be known for?",
    "All done! Feel free to read through the letter again and **add what you'd like me to know about you**!"
]

struct RandomPromptButton: View {
    let currentPrompt: LocalizedStringKey
    let onTap: (LocalizedStringKey) -> Void
    @Binding var currentPromptIndex: Int
    
    var body: some View {
        Button(action: {
            // Select a random prompt that's different from the current one
            let newIndex = (currentPromptIndex == 0) ? prompts.count - 1 : currentPromptIndex - 1
            onTap(prompts[newIndex])
            currentPromptIndex = newIndex
        }) {
            HStack {
                Text(currentPrompt)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(systemName: "arrow.counterclockwise")
                    .foregroundColor(.black.opacity(0.8))

            }
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 16)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

struct LetterView: View {
    @Binding var text: String
    @Binding var animationPhase: Int  // 0: initial, 1: expanded and rotated, 2: buttons visible
    @FocusState private var isTextFieldFocused: Bool
    @State private var buttonOffset: CGFloat = -20  // Start offscreen
    
    
    @State var currentPromptIndex = 0
    @State private var currentPrompt = prompts[0]
    
    @State var sentenceCount = 0
    
    private var isExpanded: Bool {
        animationPhase >= 1
    }
    
    private var isButtonVisible: Bool {
        animationPhase >= 2
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Done") {
                    transitionToClosedMode()
                }
                .tint(.jAccent)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .offset(y: buttonOffset)
                .opacity(isButtonVisible ? 1 : 0)
            }

            ZStack {
                // Main card view that transforms
                ZStack(alignment: .topLeading) {
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(
                            color: Color.black.opacity(isExpanded ? 0.15 : 0.1),
                            radius: isExpanded ? 8 : 4,
                            x: 0,
                            y: isExpanded ? 4 : 2)

                    // Text editor
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $text)
                            .foregroundColor(.black)
                            .tint(.jAccent)
                            .scrollContentBackground(.hidden)
                            .focused($isTextFieldFocused)
                            .onChange(of: isTextFieldFocused) { _, newValue in
                                if (newValue) {
                                    transitionToInputMode()
                                }
                            }

                        Text("Introduce yourself to Sam")
                            .allowsHitTesting(false)
                            .foregroundColor(.gray.opacity(0.7))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .opacity(text.isEmpty ? 1 : 0)
                    }
                    .padding()
                    
                    VStack {
                                            Spacer()
                                            
                                            if isExpanded && isTextFieldFocused {
                                                RandomPromptButton(
                                                    currentPrompt: currentPrompt,
                                                    onTap: { newPrompt in
                                                        withAnimation {
                                                            currentPrompt = newPrompt
                                                        }
                                                    },
                                                    currentPromptIndex: $currentPromptIndex
                                                )
                                                .padding(.horizontal, 4)
                                                .offset(y: buttonOffset * -1)
                                                .opacity(isButtonVisible ? 1 : 0)
                                            }
                                        }
                }
                .frame(
                    minWidth: isExpanded ? nil : 300,
                    maxWidth: isExpanded ? .infinity : 300,
                    minHeight: isExpanded ? nil : 400,
                    maxHeight: isExpanded ? .infinity : 400
                )
                .rotationEffect(
                    .degrees(isExpanded ? 0 : 8), anchor: .center
                )
                .animation(
                    .spring(response: 0.35, dampingFraction: 0.8),
                    value: animationPhase
                )
                .contentShape(Rectangle()) // Ensure the whole area is tappable
                .onTapGesture {
                    if animationPhase == 0 {
                        transitionToInputMode()
                    }
                }
                .onChange(of: text) { _, newValue in
                                 sentenceCount = countSentences(in: newValue)
                    let newPromptIndex = min(sentenceCount, prompts.count - 1) % prompts.count
                    self.currentPromptIndex = newPromptIndex
                    self.currentPrompt = prompts[newPromptIndex]
                             }
            }
        }
    }
    
    func transitionToInputMode() {
        // Combined rotation and expansion phase
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            animationPhase = 1
            isTextFieldFocused = true
        }
        
        // Button slide-in phase
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                animationPhase = 2
                buttonOffset = 0
            }
        }
    }
    
    func transitionToClosedMode() {
        // First hide the button
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            animationPhase = 1  // Keep expanded but hide button
            buttonOffset = -50
        }
        
        // Then collapse the card after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                animationPhase = 0
                isTextFieldFocused = false
            }
        }
    }
    
    func countSentences(in text: String) -> Int {
        let pattern = "\\(?[^.?!\\n]+[.!?\\n]\\)?"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
        let matches = regex?.matches(in: text, options: [], range: range) ?? []
        return matches.count
    }
}

// Preview
#Preview {
    @Previewable @State var animationPhase = 0;
    @Previewable @State var text = "";
    LetterView(text: $text, animationPhase: $animationPhase)
}
