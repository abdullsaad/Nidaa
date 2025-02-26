import Foundation
import SwiftData

@Model
final class PersonalizedPatientStatus {
    var id: UUID
    var patientId: UUID
    var userId: UUID
    var status: PatientStatus
    var notes: String?
    var lastUpdated: Date
    
    init(
        id: UUID = UUID(),
        patientId: UUID,
        userId: UUID,
        status: PatientStatus,
        notes: String? = nil,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.patientId = patientId
        self.userId = userId
        self.status = status
        self.notes = notes
        self.lastUpdated = lastUpdated
    }
} 