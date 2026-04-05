import Foundation
import SwiftData

@Model
class JournalEntry {
    var date: Date
    var trigger: String
    var triggerDetail: String
    var emotion: String
    var intensity: Int
    var fact: String
    var story: String
    var didAct: Bool
    var actedFrom: String?
    var outcome: String?
    var lesson: String?
    var fromProtocol: Bool
    var rawFeeling: String?

    init(
        date: Date = .now,
        trigger: String = "",
        triggerDetail: String = "",
        emotion: String = "",
        intensity: Int = 3,
        fact: String = "",
        story: String = "",
        didAct: Bool = false,
        actedFrom: String? = nil,
        outcome: String? = nil,
        lesson: String? = nil,
        fromProtocol: Bool = false,
        rawFeeling: String? = nil
    ) {
        self.date = date
        self.trigger = trigger
        self.triggerDetail = triggerDetail
        self.emotion = emotion
        self.intensity = intensity
        self.fact = fact
        self.story = story
        self.didAct = didAct
        self.actedFrom = actedFrom
        self.outcome = outcome
        self.lesson = lesson
        self.fromProtocol = fromProtocol
        self.rawFeeling = rawFeeling
    }
}

enum TriggerType: String, CaseIterable {
    case distance = "Distancia de ella"
    case socialMedia = "Redes sociales"
    case thoughts = "Pensamientos"
    case jealousy = "Celos"
    case other = "Otro"
}

enum EmotionType: String, CaseIterable {
    case anxiety = "Ansiedad"
    case jealousy = "Celos"
    case fear = "Miedo"
    case anger = "Rabia"
    case sadness = "Tristeza"
    case other = "Otro"
}

enum OutcomeType: String, CaseIterable {
    case good = "Bien"
    case bad = "Mal"
    case neutral = "Neutro"
}
