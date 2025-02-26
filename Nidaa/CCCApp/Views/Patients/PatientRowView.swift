import SwiftUI
import SwiftData

struct PatientRowView: View {
    let patient: Patient
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \User.lastName) private var users: [User]
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(patient.fullName)
                    .font(.headline)
                
                if let roomNumber = patient.roomNumber {
                    Text("Room \(roomNumber)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(patient.status.rawValue.capitalized)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.2))
                .foregroundColor(statusColor)
                .clipShape(Capsule())
        }
        .padding()
    }
    
    private var statusColor: Color {
        switch patient.status {
        case .stable:
            return .green
        case .critical:
            return .red
        case .serious:
            return .orange
        case .fair:
            return .yellow
        case .discharged:
            return .gray
        }
    }
    
    private var assignedTeamMembers: [User] {
        users.filter { patient.assignedTeam.contains($0.id) }
    }
} 