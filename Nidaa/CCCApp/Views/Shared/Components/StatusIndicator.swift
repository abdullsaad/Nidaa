import SwiftUI

struct StatusIndicator: View {
    let status: UserStatus
    
    var body: some View {
        Circle()
            .fill(statusColor)
            .frame(width: 8, height: 8)
    }
    
    private var statusColor: Color {
        switch status {
        case .active, .available:
            return .green
        case .busy, .inCall:
            return .orange
        case .offline, .inactive:
            return .gray
        case .onCall:
            return .red
        case .onLeave:
            return .yellow
        }
    }
} 