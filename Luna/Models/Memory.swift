import Foundation
import SwiftData

@Model
class Memory {
    @Attribute(.externalStorage) var imageData: Data?
    @Attribute(.externalStorage) var videoData: Data?
    var isVideo: Bool = false
    var caption: String = ""
    var place: String = ""
    var milestoneId: String?
    var createdAt: Date = Date.now

    init(imageData: Data? = nil, videoData: Data? = nil, isVideo: Bool = false, caption: String = "", place: String = "", milestoneId: String? = nil, createdAt: Date = .now) {
        self.imageData = imageData
        self.videoData = videoData
        self.isVideo = isVideo
        self.caption = caption
        self.place = place
        self.milestoneId = milestoneId
        self.createdAt = createdAt
    }
}
