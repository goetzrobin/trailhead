//
//  PromptOption.swift
//  trailhead
//
//  Created by Robin Götz on 1/22/25.
//
struct PromptOption: Identifiable, Equatable {
    var id: String { prompt }
    let prompt: String

    static func == (lhs: PromptOption, rhs: PromptOption) -> Bool {
        return lhs.id == rhs.id
    }
}
