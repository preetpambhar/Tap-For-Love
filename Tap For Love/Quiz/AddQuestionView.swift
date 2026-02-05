import SwiftUI

struct AddQuestionView: View {
    @Environment(\.dismiss) var dismiss

    @State private var questionText = ""
    @State private var options = ["", "", ""]
    @State private var correctIndex = 0
    @State private var rightMessage = "You got it right 💖"
    @State private var wrongMessage = "Oops… try harder 😏"

    let onSave: (QuizQuestion) -> Void

    var body: some View {
        NavigationStack {
            Form {

                Section("Question") {
                    TextField("Enter your question", text: $questionText)
                }

                Section("Options") {
                    ForEach(0..<options.count, id: \.self) { index in
                        HStack {
                            TextField("Option \(index + 1)", text: $options[index])
                            Spacer()
                            if correctIndex == index {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            correctIndex = index
                        }
                    }
                }

                Section("Messages") {
                    TextField("Right answer message", text: $rightMessage)
                    TextField("Wrong answer message", text: $wrongMessage)
                }
            }
            .navigationTitle("Add Question")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let question = QuizQuestion(
                            id: UUID(),
                            question: questionText,
                            options: options,
                            correctIndex: correctIndex,
                            rightMessage: rightMessage,
                            wrongMessage: wrongMessage
                        )
                        onSave(question)
                        dismiss()
                    }
                    .disabled(questionText.isEmpty || options.contains(""))
                }
            }
        }
    }
}

