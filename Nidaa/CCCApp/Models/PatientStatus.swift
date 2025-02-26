import Foundation
import SwiftUI

enum PatientStatus: String, Codable, CaseIterable {
    case stable
    case critical
    case serious
    case fair
    case discharged
}

// Move all extensions to a single place
extension PatientStatus {
    var statusColor: Color {
        switch self {
        case .stable: return .green
        case .critical: return .red
        case .serious: return .orange
        case .fair: return .yellow
        case .discharged: return .gray
        }
    }
    
    var statusIcon: String {
        switch self {
        case .stable: return "checkmark.circle.fill"
        case .critical: return "exclamationmark.triangle.fill"
        case .serious: return "exclamationmark.circle.fill"
        case .fair: return "arrow.up.circle.fill"
        case .discharged: return "house.fill"
        }
    }
} 