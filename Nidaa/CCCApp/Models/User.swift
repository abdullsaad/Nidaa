import Foundation
import SwiftData

@Model
final class User: Identifiable {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var department: String
    var specialty: String
    var role: UserRole
    var status: UserStatus
    var employeeId: String?
    var certifications: [Certification]
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    init(
        id: UUID = UUID(),
        firstName: String,
        lastName: String,
        email: String,
        phoneNumber: String = "",
        department: String = "",
        specialty: String = "",
        role: UserRole,
        status: UserStatus = .active,
        employeeId: String? = nil,
        certifications: [Certification] = []
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.department = department
        self.specialty = specialty
        self.role = role
        self.status = status
        self.employeeId = employeeId
        self.certifications = certifications
    }
    
    init() {
        self.id = UUID()
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.phoneNumber = ""
        self.department = ""
        self.specialty = ""
        self.role = .staff
        self.status = .active
        self.employeeId = ""
        self.certifications = []
    }
}

enum UserStatus: String, Codable {
    case active
    case inactive
    case available
    case busy
    case offline
    case inCall
    case onCall
    case onLeave
} 