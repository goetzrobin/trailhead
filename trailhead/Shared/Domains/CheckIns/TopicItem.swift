//
//  TopicItem.swift
//  trailhead
//
//  Created by Robin Götz on 2/25/25.
//
import Foundation

// MARK: - Topic Item Model
struct TopicItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let slug: String
}

// MARK: - Topics Data
struct TopicsData {
    static let items: [TopicItem] = [
        TopicItem(title: "Clear my head", iconName: "brain", slug: "clear-my-head-v0"),
        TopicItem(title: "Stop overthinking", iconName: "arrow.clockwise.circle", slug: "stop-overthinking-v0"),
        TopicItem(title: "Process practice", iconName: "figure.mind.and.body", slug: "process-practice-v0"),
        TopicItem(title: "Sort my thoughts", iconName: "list.bullet.rectangle.portrait", slug: "sort-my-thoughts-v0"),
        TopicItem(title: "Understand what happened", iconName: "questionmark.circle", slug: "understand-what-happened-v0"),
        TopicItem(title: "Make a decision", iconName: "arrow.left.and.right.square", slug: "make-a-decision-v0"),
        TopicItem(title: "Share a win", iconName: "star.fill", slug: "share-a-win-v0"),
        TopicItem(title: "Process feeling behind", iconName: "clock.arrow.circlepath", slug: "feel-behind-v0"),
        TopicItem(title: "Prepare for next steps", iconName: "arrow.forward.circle", slug: "prepare-for-next-steps-v0"),
        TopicItem(title: "Find support", iconName: "hand.raised.fill", slug: "find-support-v0")
    ]
}
