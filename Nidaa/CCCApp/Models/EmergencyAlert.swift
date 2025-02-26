import Foundation
import CoreLocation
import SwiftData

@Model
final class EmergencyAlert {
    var id: UUID
    var type: EmergencyType
    var details: String
    var latitude: Double?
    var longitude: Double?
    var timestamp: Date
    var initiatorId: UUID
    var respondingTeam: [UUID]
    var declinedBy: [UUID]
    var status: AlertStatus
    var resolvedAt: Date?
    
    var location: CLLocationCoordinate2D? {
        get {
            guard let latitude = latitude,
                  let longitude = longitude else {
                return nil
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue?.latitude
            longitude = newValue?.longitude
        }
    }
    
    init(
        id: UUID = UUID(),
        type: EmergencyType,
        details: String,
        location: CLLocationCoordinate2D? = nil,
        initiatorId: UUID,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.details = details
        self.latitude = location?.latitude
        self.longitude = location?.longitude
        self.initiatorId = initiatorId
        self.timestamp = timestamp
        self.respondingTeam = []
        self.declinedBy = []
        self.status = .active
    }
    
    enum EmergencyType: String, Codable {
        case medical
        case security
        case critical
    }
    
    enum AlertStatus: String, Codable {
        case active
        case resolved
        case cancelled
    }
} 