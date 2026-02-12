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
        return false
    }
    
    @available(iOS 18.2, *)
    private func generateWithAppleIntelligence(topic: String, count: Int) async throws -> [QuizQuestion] {
        return generateSmartTemplates(topic: topic, count: count)
    }
    
    private func generateSmartTemplates(topic: String, count: Int) -> [QuizQuestion] {
        let categoryTemplates = detectCategory(topic: topic)
        
        return categoryTemplates.prefix(count).map { template in
            let randomCorrectIndex = Int.random(in: 0..<template.options.count)
            let correctAnswer = template.options[randomCorrectIndex]
            
            let shuffledOptions = template.options.shuffled()
            
            let newCorrectIndex = shuffledOptions.firstIndex(of: correctAnswer) ?? 0
            
            return QuizQuestion(
                id: UUID(),
                question: template.question,
                options: shuffledOptions,
                correctIndex: newCorrectIndex,
                rightMessage: pickRandomMessage(type: .right),
                wrongMessage: pickRandomMessage(type: .wrong)
            )
        }
    }
    
    private enum MessageType {
        case right, wrong
    }
    
    private func pickRandomMessage(type: MessageType) -> String {
        switch type {
        case .right:
            return [
                "You got it right! 💖",
                "Perfect! You know me so well! 💕",
                "Exactly! 🎉",
                "Yes! That's correct! ✨",
                "Amazing! You're so good at this! 💝"
            ].randomElement() ?? "You got it right! 💖"
            
        case .wrong:
            return [
                "Oops... try again! 😏",
                "Not quite! Think harder 💭",
                "Close, but not quite! 🤔",
                "Hmm, that's not it! 😅",
                "Nice try! Keep guessing! 💪"
            ].randomElement() ?? "Oops... try again! 😏"
        }
    }
    
    private func detectCategory(topic: String) -> [(question: String, options: [String])] {
        let lowerTopic = topic.lowercased()
        
        if lowerTopic.contains("relationship") || lowerTopic.contains("us") || lowerTopic.contains("together") {
            return [
                ("What's my favorite thing about our relationship?", ["Your smile", "Our conversations", "Everything"]),
                ("What's our special song?", ["The one we heard first", "Our song", "That one song"]),
                ("Where did we first meet?", ["At a party", "Through friends", "Online"]),
                ("What's my favorite date we've had?", ["The first one", "The last one", "All of them"]),
                ("What do I love most about you?", ["Your kindness", "Your humor", "Your everything"]),
                ("What's our anniversary date?", ["In spring", "In summer", "In winter"]),
                ("What's my nickname for you?", ["Sweetie", "Babe", "Love"]),
            ]
        }
        
        if lowerTopic.contains("food") || lowerTopic.contains("favorite") || lowerTopic.contains("eat") {
            return [
                ("What's my favorite type of cuisine?", ["Italian", "Mexican", "Asian"]),
                ("What's my go-to comfort food?", ["Pizza", "Ice cream", "Chocolate"]),
                ("What's my favorite drink?", ["Coffee", "Tea", "Juice"]),
                ("What food can I not live without?", ["Pasta", "Rice", "Bread"]),
                ("What's my favorite dessert?", ["Cake", "Cookies", "Ice cream"]),
                ("What's my favorite snack?", ["Chips", "Nuts", "Fruit"]),
                ("What do I always order?", ["The usual", "Something new", "The special"]),
            ]
        }
        
        if lowerTopic.contains("hobby") || lowerTopic.contains("hobbies") || lowerTopic.contains("interest") {
            return [
                ("What's my favorite hobby?", ["Reading", "Sports", "Gaming"]),
                ("How do I spend my free time?", ["Relaxing", "Being active", "Creating"]),
                ("What's my dream hobby to try?", ["Painting", "Dancing", "Traveling"]),
                ("What activity makes me happiest?", ["Outdoor activities", "Indoor activities", "Social activities"]),
                ("What would I do all day if I could?", ["Read", "Travel", "Create"]),
                ("What's my hidden talent?", ["Music", "Art", "Sports"]),
                ("What hobby did I recently start?", ["Cooking", "Photography", "Writing"]),
            ]
        }
        
        return [
            ("What's my favorite thing about \(topic)?", ["The excitement", "The memories", "The feeling"]),
            ("How important is \(topic) to me?", ["Very important", "Somewhat important", "Extremely important"]),
            ("When did I first get into \(topic)?", ["Recently", "A while ago", "Always"]),
            ("What do I love most about \(topic)?", ["Everything", "The experience", "The joy"]),
            ("How would I describe \(topic)?", ["Amazing", "Wonderful", "The best"]),
            ("What's the best part of \(topic)?", ["The feeling", "The result", "The process"]),
            ("Who introduced me to \(topic)?", ["A friend", "Family", "Myself"]),
        ]
    }
}
