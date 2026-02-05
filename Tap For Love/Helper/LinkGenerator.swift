import Foundation

func generateShareLink(from quiz: LoveQuiz) -> URL? {
    do {
        let data = try JSONEncoder().encode(quiz)
        let base64 = data.base64EncodedString()

        let encodedString = base64.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )

        guard let encodedString else { return nil }

        let urlString = "https://yourname.github.io/lovetest/?q=\(encodedString)"
        return URL(string: urlString)

    } catch {
        print("Failed to generate link:", error)
        return nil
    }
}

