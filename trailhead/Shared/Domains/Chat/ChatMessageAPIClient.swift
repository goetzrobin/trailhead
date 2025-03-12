//
//  ChatMessageAPIClient.swift
//  trailhead
//
//  Created by Robin Götz on 2/6/25.
//
import Foundation

enum ChatAPIError: Error {
    case invalidEventFormat
    case invalidChunkData
    case messagesNotFound
}

class StreamDelegate: NSObject, URLSessionDataDelegate {
    var continuation: AsyncStream<String>.Continuation?

    func urlSession(
        _ session: URLSession, dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        if let text = String(data: data, encoding: .utf8) {
            continuation?.yield(text)  // Stream chunks as they arrive
        }
    }

    func urlSession(
        _ session: URLSession, task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        if let error = error {
            continuation?.yield(
                "data: [ERROR] Server error: \(error.localizedDescription)")
        }
        continuation?.finish()  // Signal end of stream
    }
}

@Observable class ChatMessageAPIClient {
    private let session: URLSession
    private let authProvider: AuthorizationProvider

    /// - Parameters:
    ///   - session: Defaults to `URLSession.shared`, but can be injected for testing.
    ///   - authProvider: Anything that gives you an authorization header string.
    init(
        session: URLSession = .shared,
        authProvider: AuthorizationProvider
    ) {
        self.session = session
        self.authProvider = authProvider
    }

    func streamResponse(
        message: String,
        messageType: String,
        scope: String,
        userId: UUID,
        slug: String
    ) async throws -> AsyncStream<String> {
        guard
            let url = URL(
                string: "\(env.API_ROOT_URL)/api/sessions/slug/\(slug)")
        else {
            throw URLError(.badURL)
        }

        let requestBody: [String: Any] = [
            "message": message,
            "type": messageType,
            "scope": scope,
            "userId": userId.uuidString.lowercased(),
        ]

        guard
            let jsonData = try? JSONSerialization.data(
                withJSONObject: requestBody)
        else {
            throw URLError(.cannotParseResponse)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            authProvider.authorizationHeader(),
            forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        let delegate = StreamDelegate()
        let session = URLSession(
            configuration: .default, delegate: delegate, delegateQueue: .main)

        return AsyncStream { continuation in
            delegate.continuation = continuation

            let task = session.dataTask(with: request)

            // Hold strong reference to delegate to prevent premature deallocation
            continuation.onTermination = { _ in
                // Clean up if needed
            }

            task.resume()
        }
    }

    static func parseStreamEvents(_ data: String) -> [StreamEvent] {
        // Split by newlines and filter out empty lines
        let chunks = data.components(separatedBy: "\n").filter { !$0.isEmpty }

        return chunks.compactMap { chunk in
            guard chunk.hasPrefix("data: ") else {
                print("\(chunk) has invalid format")
                return .error(ChatAPIError.invalidChunkData)
            }

            let content = String(chunk.dropFirst(6))
            guard !content.isEmpty else { return nil }

            switch content {
            case "[START]":
                return .start
            case "[DONE]":
                return .done
            default:
                guard let jsonData = content.data(using: .utf8),
                    let chunk = try? JSONDecoder().decode(
                        ChatMessageChunk.self, from: jsonData)
                else {
                    print("Failed to decode: \(content)")
                    return nil
                }
                return .chunk(chunk)
            }
        }
    }

    /// Publishes the current state of fetching stored messages.
    var fetchMessagesStatus: ResponseStatus<[StoredMessage]> = .idle

    /// Fetches all stored messages for a given session log.
    /// Calls `/api/session-logs/{sessionLogId}/messages` and decodes into `[StoredMessage]` model.
    func fetchStoredMessages(for sessionLogId: UUID, onSuccess: ((_: [StoredMessage]) -> Void)? = nil) {
        fetchMessagesStatus = .loading

        let endpoint = URL(string: env.API_ROOT_URL)!
            .appendingPathComponent("api")
            .appendingPathComponent("session-logs")
            .appendingPathComponent(sessionLogId.uuidString.lowercased())
            .appendingPathComponent("messages")  // /api/session-logs/{sessionLogId}/messages

        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue(
            authProvider.authorizationHeader(),
            forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { data, response, error in
            // Handle request failure
            if let error = error {
                DispatchQueue.main.async {
                    print("Request error:", error)
                    self.fetchMessagesStatus = .error(error)
                }
                return
            }

            // Handle missing data
            guard let data = data else {
                print("Error: No messages found")
                self.fetchMessagesStatus = .error(
                    ChatAPIError.messagesNotFound)

                return
            }

            print("decoding response")

            // Decode JSON response
            do {
                let messages = try JSONDecoder().decode(
                    [StoredMessage].self, from: data)
                print("messages decoded")
                self.fetchMessagesStatus = .success(messages)
                onSuccess?(messages)
                print("fetchmessages status updated")
            } catch {
                print("Decoding error:", error)
                self.fetchMessagesStatus = .error(error)

            }
        }
        .resume()
    }

}

// MARK: - Helper Types

enum StreamEvent {
    case start
    case chunk(ChatMessageChunk)
    case done
    case error(Error)
}
