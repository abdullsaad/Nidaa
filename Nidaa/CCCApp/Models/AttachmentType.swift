import Foundation

// Single source of truth for attachment types
enum AttachmentType: String, Codable {
    case image
    case document
    case audio
    case video
    
    var icon: String {
        switch self {
        case .image:
            return "photo"
        case .document:
            return "doc"
        case .audio:
            return "waveform"
        case .video:
            return "video"
        }
    }
    
    var allowedMimeTypes: [String] {
        switch self {
        case .image:
            return ["image/jpeg", "image/png", "image/heic"]
        case .document:
            return ["application/pdf", "application/msword", "text/plain"]
        case .audio:
            return ["audio/mpeg", "audio/wav", "audio/m4a"]
        case .video:
            return ["video/mp4", "video/quicktime"]
        }
    }
} 