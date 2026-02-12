import SwiftUI

struct AddQuestionView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var questionText: String
    @State private var options: [String]
    @State private var correctIndex: Int
    @State private var rightMessage: String
    @State private var wrongMessage: String
    
    let existingQuestion: QuizQuestion?
    let onSave: (QuizQuestion) -> Void
    
    init(existingQuestion: QuizQuestion? = nil, onSave: @escaping (QuizQuestion) -> Void) {
        self.existingQuestion = existingQuestion
        self.onSave = onSave
        
        _questionText = State(initialValue: existingQuestion?.question ?? "")
        _options = State(initialValue: existingQuestion?.options ?? ["", "", ""])
        _correctIndex = State(initialValue: existingQuestion?.correctIndex ?? 0)
        _rightMessage = State(initialValue: existingQuestion?.rightMessage ?? "You got it right 💖")
        _wrongMessage = State(initialValue: existingQuestion?.wrongMessage ?? "Oops... try harder 😏")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.purple.opacity(0.05), Color.pink.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Question", systemImage: "questionmark.circle.fill")
                                .font(.headline)
                                .foregroundColor(.purple)
                            
                            TextEditor(text: $questionText)
                                .frame(minHeight: 80)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(questionText.isEmpty ? Color.red.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Answer Options", systemImage: "list.bullet.circle.fill")
                                .font(.headline)
                                .foregroundColor(.purple)
                            
                            VStack(spacing: 12) {
                                ForEach(0..<options.count, id: \.self) { index in
                                    OptionRow(
                                        index: index,
                                        text: $options[index],
                                        isCorrect: correctIndex == index,
                                        onTap: { correctIndex = index }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Custom Messages", systemImage: "message.circle.fill")
                                .font(.headline)
                                .foregroundColor(.purple)
                            
                            VStack(spacing: 12) {
                                // Right Answer Message
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("✅ Correct Answer")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                    
                                    TextField("e.g., You got it right! 💖", text: $rightMessage)
                                        .padding()
                                        .background(Color.green.opacity(0.05))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                
                                // Wrong Answer Message
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("❌ Wrong Answer")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                    
                                    TextField("e.g., Oops... try harder 😏", text: $wrongMessage)
                                        .padding()
                                        .background(Color.red.opacity(0.05))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Button(action: saveQuestion) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text(existingQuestion == nil ? "Add Question" : "Save Changes")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: isValid ? [.purple, .pink] : [.gray, .gray],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: isValid ? .purple.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                        }
                        .disabled(!isValid)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle(existingQuestion == nil ? "Add Question" : "Edit Question")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var isValid: Bool {
        !questionText.isEmpty &&
        !options.contains("") &&
        !rightMessage.isEmpty &&
        !wrongMessage.isEmpty
    }
    
    private func saveQuestion() {
        let question = QuizQuestion(
            id: existingQuestion?.id ?? UUID(),
            question: questionText,
            options: options,
            correctIndex: correctIndex,
            rightMessage: rightMessage,
            wrongMessage: wrongMessage
        )
        onSave(question)
        dismiss()
    }
}

// MARK: - Option Row Component
struct OptionRow: View {
    let index: Int
    @Binding var text: String
    let isCorrect: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isCorrect ? Color.green : Color.gray.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Text(String(UnicodeScalar(65 + index)!)) // A, B, C
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isCorrect ? .white : .gray)
            }
            .onTapGesture(perform: onTap)
            
            TextField("Option \(index + 1)", text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(text.isEmpty ? Color.red.opacity(0.3) : (isCorrect ? Color.green : Color.gray.opacity(0.2)), lineWidth: 1)
                )
            
            if isCorrect {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
            }
        }
    }
}

// Preview
#Preview {
    AddQuestionView { _ in }
}
