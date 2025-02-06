//
//  MentorQuality.swift
//  trailhead
//
//  Created by Robin Götz on 1/20/25.
//

struct MentorQuality: Identifiable, Hashable {
    var id: String { name }  // Using name as id
    let name: String
    let description: String
}

let ALL_MENTOR_QUALITIES: [MentorQuality] = [
    MentorQuality(
        name: "Courage",
        description:
            "Faces life's messiness with grace, showing us how to do the same"),
    MentorQuality(
        name: "Wisdom",
        description:
            "Knows the difference between information and understanding"),
    MentorQuality(
        name: "Presence",
        description: "Truly listens, without rushing to fix or judge"),
    MentorQuality(
        name: "Curiosity",
        description: "Delights in questions more than answers"),
    MentorQuality(
        name: "Truth",
        description: "Gentle with feelings, uncompromising with reality"),
    MentorQuality(
        name: "Depth",
        description: "Comfortable sitting with life's contradictions"),
    MentorQuality(
        name: "Challenge",
        description: "Knows we grow most when we're slightly uncomfortable"),
    MentorQuality(
        name: "Insight",
        description: "Sees patterns we've missed in our own story"),
    MentorQuality(
        name: "Trust", description: "Creates a space where doubts can be voiced"
    ),
    MentorQuality(
        name: "Heart", description: "Brings warmth to difficult conversations"),
    MentorQuality(
        name: "Spirit",
        description: "Reminds us of life's poetry, not just its prose"),
    MentorQuality(
        name: "Vision",
        description: "Helps us imagine better versions of ourselves"),
    MentorQuality(
        name: "Faith",
        description: "Holds hope for us when we've misplaced our own"),
    MentorQuality(
        name: "Purpose", description: "Helps us find meaning in the everyday"),
]
