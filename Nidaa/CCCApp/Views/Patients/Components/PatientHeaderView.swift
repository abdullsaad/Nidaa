import SwiftUI

struct PatientHeaderView: View {
    let patient: Patient
    
    var body: some View {
        VStack(spacing: 12) {
            // Patient name and room - more prominent
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(patient.fullName)
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        Text("MRN: \(patient.medicalRecordNumber)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Make room number more prominent
                if let roomNumber = patient.roomNumber {
                    VStack(alignment: .center) {
                        Text("Room")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(roomNumber)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.accentColor)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            
            Divider()
            
            // Patient demographics and status
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("DOB: \(patient.dateOfBirth.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Age: \(patient.age) years")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Status badge
                HStack {
                    Circle()
                        .fill(patient.status.statusColor)
                        .frame(width: 8, height: 8)
                    
                    Text(patient.status.rawValue.capitalized)
                        .font(.subheadline)
                        .foregroundColor(patient.status.statusColor)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(patient.status.statusColor.opacity(0.1))
                .cornerRadius(20)
            }
            
            // Quick Stats - simplified and more visual
            HStack(spacing: 24) {
                if let weight = patient.weight {
                    StatBadge(
                        value: "\(Int(weight))",
                        unit: "kg",
                        icon: "scalemass.fill"
                    )
                }
                
                if let height = patient.height {
                    StatBadge(
                        value: "\(Int(height))",
                        unit: "cm",
                        icon: "ruler.fill"
                    )
                }
                
                if let bmi = patient.bmi {
                    StatBadge(
                        value: String(format: "%.1f", bmi),
                        unit: "BMI",
                        icon: "figure.arms.open"
                    )
                }
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

// New component for stats with better visual hierarchy
struct StatBadge: View {
    let value: String
    let unit: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.headline)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

private struct InfoStat: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
            
            Text(value)
                .font(.headline)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct AlertBadge: View {
    let alert: Alert
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(alertColor)
                .frame(width: 8, height: 8)
            
            Text(alert.message)
                .font(.caption)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(alertColor.opacity(0.1))
        .foregroundColor(alertColor)
        .clipShape(Capsule())
    }
    
    private var alertColor: Color {
        switch alert.type {
        case .critical: return .red
        case .urgent: return .orange
        case .normal: return .blue
        case .info: return .gray
        }
    }
} 