import SwiftUI

struct QuizView: View {
    let encodedQuiz: String

    @State private var quiz: LoveQuiz?
    @State private var answers: [Int] = []
    @State private var showResult = false
    @State private var score = 0

    var body: some View {
        Group {
            if let quiz = quiz {
                VStack(spacing: 20) {
                    Text(quiz.title).font(.title).bold()

                    if !showResult {
                        List(quiz.questions.indices, id: \.self) { idx in
                            let q = quiz.questions[idx]
                            VStack(alignment: .leading) {
                                Text(q.question).bold()
                                ForEach(q.options.indices, id: \.self) { i in
                                    Button(action: {
                                        answers[idx] = i
                                    }) {
                                        HStack {
                                            Image(systemName: answers[idx] == i ? "largecircle.fill.circle" : "circle")
                                            Text(q.options[i])
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, 5)
                        }

                        Button("Submit 💘") {
                            calculateScore()
                        }
                        .padding()
                    } else {
                        Text("You got \(score)/\(quiz.questions.count) correct! \(quiz.finalMessage)")
                            .font(.headline)
                    }
                }
                .padding()
            } else {
                Text("Loading quiz… 💭")
                    .onAppear {
                        decodeQuiz()
                    }
            }
        }
    }

    private func decodeQuiz() {
        guard let data = Data(base64Encoded: encodedQuiz) else { return }
        do {
            quiz = try JSONDecoder().decode(LoveQuiz.self, from: data)
            answers = Array(repeating: -1, count: quiz?.questions.count ?? 0)
        } catch {
            print("❌ Failed to decode quiz:", error)
        }
    }

    private func calculateScore() {
        guard let quiz = quiz else { return }
        score = zip(quiz.questions, answers).filter { $0.correctIndex == $1 }.count
        showResult = true
    }
}
