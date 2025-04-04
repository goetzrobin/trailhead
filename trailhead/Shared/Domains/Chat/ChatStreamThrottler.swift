import Foundation

actor StreamThrottler {
    private var queue: [ChatMessageChunk] = []
    private var isProcessing = false
    private let maxChunksPerSecond: Double
    private let randomVariation: Double
    private var callback: ((ChatMessageChunk) -> Void)?
    
    init(maxChunksPerSecond: Double = 1000, randomVariation: Double = 0.4) {
        self.maxChunksPerSecond = maxChunksPerSecond
        self.randomVariation = randomVariation
    }
    
    func setCallback(_ callback: @escaping (ChatMessageChunk) -> Void) {
        self.callback = callback
    }
    
    func enqueueChunk(_ chunk: ChatMessageChunk) {
        queue.append(chunk)
        processQueueIfNeeded()
    }
    
    private func processQueueIfNeeded() {
        guard !isProcessing else { return }
        isProcessing = true
        
        Task {
            while !queue.isEmpty {
                let chunk = queue.removeFirst()
                let baseDelay = 1.0 / maxChunksPerSecond
                let variation = Double.random(in: -randomVariation...randomVariation)
                let delay = baseDelay * (1 + variation)
                
                try? await Task.sleep(for: .seconds(0))
                if let callback = callback {
                    await MainActor.run {
                        callback(chunk)
                    }
                }
            }
            isProcessing = false
        }
    }
    
    func clear() {
        queue.removeAll()
        isProcessing = false
    }
}
