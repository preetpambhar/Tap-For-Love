import SwiftUI

struct CreateQuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var showAddQuestion = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                TextField("Quiz Title", text: $viewModel.title)
                    .textFieldStyle(.roundedBorder)

                List {
                    ForEach(viewModel.questions) { question in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(question.question)
                                .font(.headline)
                            Text("Correct: \(question.options[question.correctIndex])")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                }

                Button("➕ Add Question") {
                    showAddQuestion = true
                }
                .buttonStyle(.borderedProminent)

                Button("Generate Love Link 💘") {
                    let quiz = viewModel.buildQuiz()
                    if let url = generateShareLink(from: quiz) {
                        print(url.absoluteString)
                    }
                }
                .disabled(viewModel.questions.isEmpty)

            }
            .padding()
            .navigationTitle("Create Love Game")
            .sheet(isPresented: $showAddQuestion) {
                AddQuestionView { newQuestion in
                    viewModel.addQuestion(newQuestion)
                }
            }
        }
    }
}

