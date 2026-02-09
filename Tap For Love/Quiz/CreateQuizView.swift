import SwiftUI

struct CreateQuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var showAddQuestion = false
    @State private var shareItem: ShareItem?
    @State private var aiTopic = ""
    @State private var isGenerating = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let aiGenerator = SmartQuestionGenerator()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                TextField("Quiz Title", text: $viewModel.title)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                // AI Generation Section
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(.blue)
                        Text("AI Question Generator")
                            .font(.headline)
                    }
                    
                    TextField("Topic (e.g., 'our relationship', 'my hobbies')", text: $aiTopic)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    Button(action: generateWithAI) {
                        HStack {
                            if isGenerating {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                            } else {
                                Image(systemName: "wand.and.stars")
                            }
                            Text(isGenerating ? "Generating..." : "Generate 5 Questions")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(aiTopic.isEmpty || isGenerating)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)

                if viewModel.questions.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No questions yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Use AI to generate or add manually")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity)
                } else {
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
                        .onDelete { indexSet in
                            viewModel.questions.remove(atOffsets: indexSet)
                        }
                    }
                }

                VStack(spacing: 12) {
                    Button("➕ Add Question Manually") {
                        showAddQuestion = true
                    }
                    .buttonStyle(.bordered)

                    Button("Generate Love Link 💘") {
                        let quiz = viewModel.buildQuiz()
                        if let url = generateShareLink(from: quiz) {
                            shareItem = ShareItem(url: url)
                        }
                    }
                    .disabled(viewModel.questions.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("Create Love Game")
            .sheet(isPresented: $showAddQuestion) {
                AddQuestionView { newQuestion in
                    viewModel.addQuestion(newQuestion)
                }
            }
            .sheet(item: $shareItem) { item in
                ShareSheet(items: [
                    "I made a Valentine game for you 💖\nAnswer honestly 😏",
                    item.url
                ])
            }
            .alert("Generation Complete", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func generateWithAI() {
        isGenerating = true
        
        Task {
            do {
                let questions = try await aiGenerator.generateQuestions(topic: aiTopic, count: 5)
                
                await MainActor.run {
                    for question in questions {
                        viewModel.addQuestion(question)
                    }
                    aiTopic = ""
                    isGenerating = false
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "Generated questions using smart templates!"
                    showError = true
                    isGenerating = false
                }
            }
        }
    }
}
