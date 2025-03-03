//
//  PromptOption.swift
//  trailhead
//
//  Created by Robin Götz on 1/22/25.
//
import Foundation

struct PromptOption: Identifiable, Equatable {
    var id: UUID
    let prompt: String

    static func == (lhs: PromptOption, rhs: PromptOption) -> Bool {
        return lhs.id == rhs.id
    }
}
