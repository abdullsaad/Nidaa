import Foundation
import Network

struct NetworkStatus: Equatable {
    let isAvailable: Bool
    let connectionType: ConnectionType
    let quality: CallQuality?
    
    static let connected = NetworkStatus(
        isAvailable: true,
        connectionType: .wifi,
        quality: nil
    )
    
    static let disconnected = NetworkStatus(
        isAvailable: false,
        connectionType: .unknown,
        quality: nil
    )
}

enum ConnectionType: String, Codable {
    case wifi
    case cellular
    case ethernet
    case unknown
} 