import Foundation

struct CallStats {
    let bitrate: Int
    let packetLoss: Double
    let latency: Int
    let resolution: String
    let quality: CallQuality
}

enum CallQuality: String {
    case excellent
    case good
    case fair
    case poor
    case bad
    
    var description: String {
        rawValue.capitalized
    }
    
    static func from(stats: CallStats) -> CallQuality {
        if stats.packetLoss < 0.5 && stats.latency < 50 {
            return .excellent
        } else if stats.packetLoss < 1.0 && stats.latency < 100 {
            return .good
        } else if stats.packetLoss < 2.0 && stats.latency < 150 {
            return .fair
        } else if stats.packetLoss < 5.0 && stats.latency < 200 {
            return .poor
        } else {
            return .bad
        }
    }
} 