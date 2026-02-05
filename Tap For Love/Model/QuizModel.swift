import Foundation

struct LoveQuiz: Codable {
    let title: String
    let questions: [QuizQuestion]
    let finalMessage: String
}

struct QuizQuestion: Codable, Identifiable {
    let id: UUID
    let question: String
    let options: [String]
    let correctIndex: Int
    let rightMessage: String
    let wrongMessage: String
}


let sampleQuiz = LoveQuiz(
    title: "How Well Do You Know Me? 💖",
    questions: [
        QuizQuestion(
            id: UUID(),
            question: "What’s my favorite chocolate?",
            options: ["Dairy Milk", "KitKat", "Ferrero Rocher"],
            correctIndex: 2,
            rightMessage: "Okay wow, you really know me 😌",
            wrongMessage: "That hurt… I expected better 💔"
        )
    ],
    finalMessage: "You passed the love test 💘"
)
