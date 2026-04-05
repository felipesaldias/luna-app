import Foundation
import SwiftData

@Model
class Memory {
    @Attribute(.externalStorage) var imageData: Data?
    var caption: String
    var createdAt: Date

    init(imageData: Data? = nil, caption: String = "", createdAt: Date = .now) {
        self.imageData = imageData
        self.caption = caption
        self.createdAt = createdAt
    }
}
