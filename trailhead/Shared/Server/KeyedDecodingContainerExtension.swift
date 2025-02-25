//
//  KeyedDecodingContainerExtension.swift
//  trailhead
//
//  Created by Robin Götz on 2/17/25.
//
import Foundation

extension KeyedDecodingContainer {
    func decodeDate(forKey key: KeyedDecodingContainer.Key) -> Date? {
        if let dateString = try? self.decode(String.self, forKey: key) {
            if let date = DateFormatter.iso8601WithTime.date(from: dateString) {
                return date
            } else if let date = DateFormatter.iso8601DateOnly.date(from: dateString) {
                return date
            }
        }
        return nil
    }
}
