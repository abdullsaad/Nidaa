import Foundation
import SwiftData

@Model
final class Patient {
    var id: UUID
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var medicalRecordNumber: String  // Hospital MRN
    var wardInfo: WardInfo
    var roomNumber: String?
    var assignedTeam: [UUID]
    var status: PatientStatus
    var bloodType: PatientBloodType?
    var weight: Double?
    var height: Double?
    var allergies: [String]
    var alerts: [PatientAlert]
    var vitalSigns: [VitalSign]
    var medications: [Medication]
    var chiefComplaint: String?
    var activeProblems: [String] = []
    
    init(
        id: UUID = UUID(),
        firstName: String,
        lastName: String,
        dateOfBirth: Date,
        medicalRecordNumber: String,
        wardInfo: WardInfo,
        roomNumber: String?,
        assignedTeam: [UUID],
        status: PatientStatus,
        chiefComplaint: String? = nil,
        activeProblems: [String] = [],
        bloodType: PatientBloodType? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.medicalRecordNumber = medicalRecordNumber
        self.wardInfo = wardInfo
        self.roomNumber = roomNumber
        self.assignedTeam = assignedTeam
        self.status = status
        self.chiefComplaint = chiefComplaint
        self.activeProblems = activeProblems
        self.bloodType = bloodType
        self.allergies = []
        self.alerts = []
        self.vitalSigns = []
        self.medications = []
    }
    
    init() {
        self.id = UUID()
        self.firstName = ""
        self.lastName = ""
        self.dateOfBirth = Date()
        self.medicalRecordNumber = ""
        self.wardInfo = WardInfo(floorNumber: 0, wardNumber: "", bedNumber: "")
        self.roomNumber = ""
        self.assignedTeam = []
        self.status = .stable
        self.chiefComplaint = nil
        self.activeProblems = []
        self.allergies = []
        self.alerts = []
        self.vitalSigns = []
        self.medications = []
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: dateOfBirth, to: .now).year ?? 0
    }
    
    var bmi: Double? {
        guard let height = height, let weight = weight, height > 0 else { return nil }
        let heightInMeters = height / 100
        return weight / (heightInMeters * heightInMeters)
    }
    
    func checkAutoAssignment(context: ModelContext) {
        // Get all unit assignments
        let descriptor = FetchDescriptor<UnitAssignment>()
        
        if let assignments = try? context.fetch(descriptor) {
            // Filter manually
            let matchingAssignments = assignments.filter { 
                $0.wardNumber == self.wardInfo.wardNumber 
            }
            
            // Apply assignments
            for assignment in matchingAssignments {
                if !self.assignedTeam.contains(assignment.userId) {
                    self.assignedTeam.append(assignment.userId)
                }
            }
        }
    }
    
    struct WardInfo: Codable {
        var floorNumber: Int
        var wardNumber: String  // e.g., "3A", "ICU-1"
        var bedNumber: String   // e.g., "301-A"
    }
}

@Model
final class PatientAlert {
    var id: UUID
    var type: PatientAlertType
    var message: String
    var timestamp: Date
    var isActive: Bool
    var location: String?
    
    init(
        id: UUID = UUID(),
        type: PatientAlertType,
        message: String,
        location: String? = nil,
        timestamp: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.type = type
        self.message = message
        self.location = location
        self.timestamp = timestamp
        self.isActive = isActive
    }
}

enum PatientAlertType: String, Codable {
    case critical
    case urgent
    case normal
    case info
}

enum PatientBloodType: String, Codable, CaseIterable {
    case aPositive = "A+"
    case aNegative = "A-"
    case bPositive = "B+"
    case bNegative = "B-"
    case oPositive = "O+"
    case oNegative = "O-"
    case abPositive = "AB+"
    case abNegative = "AB-"
}

@Model
final class Medication: Identifiable {
    var id: UUID
    var name: String
    var dosage: String
    var frequency: String
    var startDate: Date
    var endDate: Date?
    var notes: String?
    
    init(
        id: UUID = UUID(),
        name: String,
        dosage: String,
        frequency: String,
        startDate: Date,
        endDate: Date? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
    }
}

@Model
final class VitalSign: Identifiable {
    var id: UUID
    var timestamp: Date
    var type: VitalSignType
    var value: Double
    var unit: String
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        type: VitalSignType,
        value: Double,
        unit: String
    ) {
        self.id = id
        self.timestamp = timestamp
        self.type = type
        self.value = value
        self.unit = unit
    }
}

enum VitalSignType: String, Codable, CaseIterable {
    case bloodPressure = "Blood Pressure"
    case heartRate = "Heart Rate"
    case temperature = "Temperature"
    case oxygenSaturation = "Oxygen Saturation"
    case respiratoryRate = "Respiratory Rate"
} 
