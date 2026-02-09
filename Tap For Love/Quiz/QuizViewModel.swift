import Foundation
import Combine

class QuizViewModel: ObservableObject {
    @Published var title: String = "How Well Do You Know Me? 💘"
    @Published var questions: [QuizQuestion] = []
    @Published var finalMessage: String = "You passed the love test 💖"

    func addQuestion(_ question: QuizQuestion) {
        questions.append(question)
    }
    
    func deleteQuestion(at index: Int) {
        guard index >= 0 && index < questions.count else { return }
        questions.remove(at: index)
    }

    func buildQuiz() -> LoveQuiz {
        return LoveQuiz(
            title: title,
            questions: questions,
            finalMessage: finalMessage
        )
    }
}
