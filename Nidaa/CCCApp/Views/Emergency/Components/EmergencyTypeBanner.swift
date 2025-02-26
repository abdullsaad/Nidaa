import SwiftUI

struct EmergencyTypeBanner: View {
    let type: EmergencyAlert.EmergencyType
    
    var body: some View {
        HStack {
            Image(systemName: typeIcon)
                .foregroundColor(typeColor)
            
            Text(type.rawValue.capitalized)
                .font(.headline)
                .foregroundColor(typeColor)
        }
        .padding()
        .background(typeColor.opacity(0.1))
        .cornerRadius(10)
    }
    
    private var typeColor: Color {
        switch type {
        case .medical:
            return .red
        case .security:
            return .blue
        case .critical:
            return .orange
        }
    }
    
    private var typeIcon: String {
        switch type {
        case .medical:
            return "cross.case.fill"
        case .security:
            return "shield.fill"
        case .critical:
            return "exclamationmark.triangle.fill"
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        EmergencyTypeBanner(type: .medical)
        EmergencyTypeBanner(type: .security)
        EmergencyTypeBanner(type: .critical)
    }
    .padding()
} 

