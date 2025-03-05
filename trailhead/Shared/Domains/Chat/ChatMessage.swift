import Foundation

protocol ChatMessage: Codable {
    var id: String { get }
    var content: String { get }
    var type: ChatMessageType { get }
    var scope: ChatMessageScope { get }
    var createdAt: Date { get }
    var currentStep: Int? { get }
    var stepRepetitions: Int? { get }
    var hasError: Bool { get }
}

enum ChatMessageType: String, Codable {
    case aiMessage = "ai-message"
    case toolCall = "tool-call"
    case userMessage = "user-message"
    case analyzer = "analyzer"
    case executeStep = "execute-step"
    case error = "error"
}

enum ChatMessageScope: String, Codable {
    case `internal`
    case external
}

enum ChatMessageFormatVersion: Int, Codable {
    case v1 = 1
}
