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
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Title Section
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "heart.text.square.fill")
                                    .font(.title2)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.purple, .pink],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                TextField("Quiz Title", text: $viewModel.title)
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // AI Generation Card
                        VStack(spacing: 16) {
                            // Header
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.purple, .pink],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("AI Question Generator")
                                        .font(.headline)
                                    Text("Powered by Smart Templates")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            
                            // Topic Input
                            HStack(spacing: 12) {
                                Image(systemName: "text.bubble.fill")
                                    .foregroundColor(.purple)
                                
                                TextField("e.g., 'our relationship', 'my hobbies'", text: $aiTopic)
                                    .textFieldStyle(.plain)
                            }
                            .padding()
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(12)
                            
                            // Generate Button
                            Button(action: generateWithAI) {
                                HStack(spacing: 8) {
                                    if isGenerating {
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "wand.and.stars")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    Text(isGenerating ? "Generating..." : "Generate 5 Questions")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        colors: aiTopic.isEmpty ? [.gray, .gray] : [.purple, .pink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .disabled(aiTopic.isEmpty || isGenerating)
                            .animation(.easeInOut, value: aiTopic.isEmpty)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .purple.opacity(0.1), radius: 10, x: 0, y: 4)
                        .padding(.horizontal)
                        
                        // Questions Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Questions")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("\(viewModel.questions.count)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(
                                        LinearGradient(
                                            colors: [.purple, .pink],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            
                            if viewModel.questions.isEmpty {
                                // Empty State
                                VStack(spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.purple.opacity(0.1))
                                            .frame(width: 100, height: 100)
                                        
                                        Image(systemName: "questionmark.circle.fill")
                                            .font(.system(size: 50))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [.purple, .pink],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    }
                                    
                                    VStack(spacing: 8) {
                                        Text("No Questions Yet")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Text("Use AI to generate questions or add them manually")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 40)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 60)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                                .padding(.horizontal)
                                
                            } else {
                                // Questions List
                                VStack(spacing: 12) {
                                    ForEach(Array(viewModel.questions.enumerated()), id: \.element.id) { index, question in
                                        QuestionCard(
                                            number: index + 1,
                                            question: question,
                                            onDelete: {
                                                withAnimation {
                                                    viewModel.deleteQuestion(at: index)
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Bottom Actions
                        VStack(spacing: 12) {
                            Button(action: { showAddQuestion = true }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 20))
                                    Text("Add Question Manually")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.white)
                                .foregroundColor(.purple)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.purple, lineWidth: 2)
                                )
                            }
                            
                            Button(action: {
                                let quiz = viewModel.buildQuiz()
                                if let url = generateShareLink(from: quiz) {
                                    shareItem = ShareItem(url: url)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 18))
                                    Text("Generate Love Link")
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: viewModel.questions.isEmpty ? [.gray, .gray] : [.purple, .pink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: viewModel.questions.isEmpty ? .clear : .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .disabled(viewModel.questions.isEmpty)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Create Love Game")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddQuestion) {
                AddQuestionView { newQuestion in
                    withAnimation {
                        viewModel.addQuestion(newQuestion)
                    }
                }
            }
            .sheet(item: $shareItem) { item in
                ShareSheet(items: [
                    "I made a Valentine game for you 💖\nAnswer honestly 😏",
                    item.url
                ])
            }
            .alert("Success!", isPresented: $showError) {
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
                    withAnimation(.spring()) {
                        for question in questions {
                            viewModel.addQuestion(question)
                        }
                    }
                    aiTopic = ""
                    isGenerating = false
                    errorMessage = "Successfully generated \(questions.count) questions!"
                    showError = true
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

// MARK: - Question Card Component
struct QuestionCard: View {
    let number: Int
    let question: QuizQuestion
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Number Badge
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.2), .pink.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                
                Text("\(number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.purple)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(question.question)
                    .font(.body)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text(question.options[question.correctIndex])
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
            
            // Delete Button
            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.red.opacity(0.7))
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// Preview
#Preview {
    CreateQuizView()
}
