import Foundation
import SwiftData

@Model
final class Attachment: Identifiable, Codable {
    var id: UUID
    var type: AttachmentType
    var url: URL
    var name: String
    var size: Int64
    var mimeType: String
    var imageID: String?
    
    init(
        id: UUID = UUID(),
        type: AttachmentType,
        url: URL,
        name: String,
        size: Int64,
        mimeType: String,
        imageID: String? = nil
    ) {
        self.id = id
        self.type = type
        self.url = url
        self.name = name
        self.size = size
        self.mimeType = mimeType
        self.imageID = imageID
    }
    
    enum CodingKeys: String, CodingKey {
        case id, type, url, name, size, mimeType
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(AttachmentType.self, forKey: .type)
        url = try container.decode(URL.self, forKey: .url)
        name = try container.decode(String.self, forKey: .name)
        size = try container.decode(Int64.self, forKey: .size)
        mimeType = try container.decode(String.self, forKey: .mimeType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
        try container.encode(name, forKey: .name)
        try container.encode(size, forKey: .size)
        try container.encode(mimeType, forKey: .mimeType)
    }
}

