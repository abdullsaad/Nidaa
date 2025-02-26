import SwiftUI

struct PatientInfoCard: View {
    let patient: Patient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(patient.fullName)
                .font(.headline)
            
            HStack {
                Label("Room \(patient.roomNumber ?? "N/A")", systemImage: "bed.double")
                Spacer()
                PatientStatusIndicator(status: patient.status)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
} 