import Foundation

func generateShareLink(from quiz: LoveQuiz) -> URL? {
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = []
        
        let data = try encoder.encode(quiz)
        let base64 = data.base64EncodedString()

        let encodedString = base64.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )

        guard let encodedString else { return nil }

        let urlString = "https://tap-for-love-web.vercel.app/?q=\(encodedString)"
        return URL(string: urlString)

    } catch {
        print("Failed to generate link:", error)
        return nil
    }
}
