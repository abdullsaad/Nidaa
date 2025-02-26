import SwiftUI
import SwiftData

struct MessageBubble: View {
    let message: Message
    @StateObject private var userManager = UserManager.shared
    @Environment(\.modelContext) private var modelContext
    @State private var selectedAttachment: Attachment?
    @State private var showingPreview = false
    
    // Create a formatter as a static property for efficiency
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var isFromCurrentUser: Bool {
        guard let currentUser = userManager.getCurrentUser() else { return false }
        return message.senderId == currentUser.id
    }
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                // Message content
                Text(message.content)
                    .padding(12)
                    .background(isFromCurrentUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(isFromCurrentUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Timestamp
                Text(formattedTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            
            if !isFromCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal, 8)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: message.timestamp)
    }
    
    private var backgroundColor: Color {
        switch message.messageType {
        case .text:
            return isFromCurrentUser ? .accentColor : Color(.systemGray6)
        case .alert:
            return .red.opacity(0.1)
        case .broadcast:
            return .purple.opacity(0.1)
        }
    }
    
    private var textColor: Color {
        switch message.messageType {
        case .text:
            return isFromCurrentUser ? .white : .primary
        case .alert, .broadcast:
            return .primary
        }
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Current user message
            MessageBubble(
                message: Message(
                    senderId: UserManager.shared.getCurrentUser()?.id ?? UUID(),
                    recipientId: UUID(),
                    content: "Hello, how are you doing today?",
                    status: .sent,
                    timestamp: Date()
                )
            )
            
            // Other user message
            MessageBubble(
                message: Message(
                    senderId: UUID(),
                    recipientId: UserManager.shared.getCurrentUser()?.id ?? UUID(),
                    content: "I'm doing well, thanks for asking!",
                    status: .read,
                    timestamp: Date().addingTimeInterval(-300)
                )
            )
        }
        .padding()
    }
}

struct MessageTypeIndicator: View {
    let type: MessageType
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .imageScale(.small)
            Text(type.rawValue.capitalized)
                .font(.caption)
                .textCase(.uppercase)
        }
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .clipShape(Capsule())
    }
    
    private var icon: String {
        switch type {
        case .alert: return "exclamationmark.triangle.fill"
        case .broadcast: return "broadcast.and.waveform"
        case .text: return "bubble.left.fill"
        }
    }
    
    private var color: Color {
        switch type {
        case .alert: return .red
        case .broadcast: return .purple
        case .text: return .accentColor
        }
    }
} 