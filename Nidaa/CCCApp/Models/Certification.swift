import Foundation

struct Certification: Identifiable, Codable {
    let id: UUID
    let name: String
    let expirationDate: Date
    let issuingAuthority: String
    
    init(id: UUID = UUID(), name: String, expirationDate: Date, issuingAuthority: String) {
        self.id = id
        self.name = name
        self.expirationDate = expirationDate
        self.issuingAuthority = issuingAuthority
    }
} 