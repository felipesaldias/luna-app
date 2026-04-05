import Foundation
import SwiftData

@Model
class Milestone {
    var title: String
    var detail: String
    var date: Date
    var icon: String
    var createdAt: Date

    init(title: String, detail: String = "", date: Date = .now, icon: String = "heart.fill", createdAt: Date = .now) {
        self.title = title
        self.detail = detail
        self.date = date
        self.icon = icon
        self.createdAt = createdAt
    }
}

let milestoneIcons = [
    "heart.fill",
    "star.fill",
    "house.fill",
    "airplane",
    "gift.fill",
    "fork.knife",
    "music.note",
    "sun.max.fill",
    "moon.fill",
    "flag.fill",
    "trophy.fill",
    "camera.fill",
    "hands.clap.fill",
    "sparkles",
]
