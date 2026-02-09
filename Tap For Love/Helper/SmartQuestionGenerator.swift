import Foundation

class SmartQuestionGenerator {
    
    func generateQuestions(topic: String, count: Int = 5) async throws -> [QuizQuestion] {
        if #available(iOS 18.2, *), await checkAppleIntelligenceAvailable() {
            return try await generateWithAppleIntelligence(topic: topic, count: count)
        }
        
        return generateSmartTemplates(topic: topic, count: count)
    }
    
    @available(iOS 18.2, *)
    private func checkAppleIntelligenceAvailable() async -> Bool {
        return false // Currently not publicly available
    }
    
    @available(iOS 18.2, *)
    private func generateWithAppleIntelligence(topic: String, count: Int) async throws -> [QuizQuestion] {
        return generateSmartTemplates(topic: topic, count: count)
    }
    
    private func generateSmartTemplates(topic: String, count: Int) -> [QuizQuestion] {
        let categoryTemplates = detectCategory(topic: topic)
        
        return categoryTemplates.prefix(count).map { template in
            QuizQuestion(
                id: UUID(),
                question: template.question,
                options: template.options,
                correctIndex: 1,
                rightMessage: "You got it right! 💖",
                wrongMessage: "Oops... try again! 😏"
            )
        }
    }
    
    private func detectCategory(topic: String) -> [(question: String, options: [String])] {
        let lowerTopic = topic.lowercased()
        
        if lowerTopic.contains("relationship") || lowerTopic.contains("us") || lowerTopic.contains("together") {
            return [
                ("What's my favorite thing about our relationship?", ["Your smile", "Our conversations", "Everything"]),
                ("What's our special song?", ["Song A", "Song B", "Song C"]),
                ("Where did we first meet?", ["Place A", "Place B", "Place C"]),
                ("What's my favorite date we've had?", ["First date", "Last date", "All of them"]),
                ("What do I love most about you?", ["Your kindness", "Your humor", "Everything"]),
            ]
        }
        
        // Food-related
        if lowerTopic.contains("food") || lowerTopic.contains("favorite") || lowerTopic.contains("eat") {
            return [
                ("What's my favorite type of cuisine?", ["Italian", "Mexican", "Asian"]),
                ("What's my go-to comfort food?", ["Pizza", "Ice cream", "Chocolate"]),
                ("What's my favorite drink?", ["Coffee", "Tea", "Soda"]),
                ("What food can I not live without?", ["Pasta", "Rice", "Bread"]),
                ("What's my favorite dessert?", ["Cake", "Cookies", "Ice cream"]),
            ]
        }
        
        if lowerTopic.contains("hobby") || lowerTopic.contains("hobbies") || lowerTopic.contains("interest") {
            return [
                ("What's my favorite hobby?", ["Reading", "Sports", "Gaming"]),
                ("How do I spend my free time?", ["Relaxing", "Being active", "Creating"]),
                ("What's my dream hobby to try?", ["Painting", "Dancing", "Traveling"]),
                ("What activity makes me happiest?", ["Option A", "Option B", "Option C"]),
                ("What would I do all day if I could?", ["Option A", "Option B", "Option C"]),
            ]
        }
        
        return [
            ("What's my favorite thing about \(topic)?", ["The excitement", "The memories", "The feeling"]),
            ("How important is \(topic) to me?", ["Very important", "Somewhat important", "Extremely important"]),
            ("When did I first get into \(topic)?", ["Recently", "A while ago", "Always"]),
            ("What do I love most about \(topic)?", ["Everything", "The experience", "The joy it brings"]),
            ("How would I describe \(topic)?", ["Amazing", "Wonderful", "The best"]),
        ]
    }
}
