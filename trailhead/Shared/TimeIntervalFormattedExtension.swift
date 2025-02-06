//
//  TimeIntervalFormattedExtension.swift
//  trailhead
//
//  Created by Robin Götz on 2/6/25.
//
import Foundation

extension TimeInterval {
    var formatted: String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        if minutes > 0 {
            return seconds > 0 ? "\(minutes)m \(seconds)s" : "\(minutes)m"
        }
        return "\(seconds)s"
    }
}
