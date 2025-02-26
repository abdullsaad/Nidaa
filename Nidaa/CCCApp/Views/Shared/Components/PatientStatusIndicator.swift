import SwiftUI

struct PatientStatusIndicator: View {
    let status: PatientStatus
    
    var body: some View {
        Circle()
            .fill(statusColor)
            .frame(width: 8, height: 8)
    }
    
    private var statusColor: Color {
        switch status {
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
} 