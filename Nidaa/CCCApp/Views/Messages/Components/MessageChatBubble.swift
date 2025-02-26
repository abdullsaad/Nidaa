import SwiftUI

struct MessageChatBubble: View {
    let message: Message
    @StateObject private var userManager = UserManager.shared
    
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
}

struct MessageChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Current user message
            MessageChatBubble(
                message: Message(
                    senderId: UserManager.shared.getCurrentUser()?.id ?? UUID(),
                    recipientId: UUID(),
                    content: "Hello, how are you doing today?",
                    attachments: [],
                    status: .sent,
                    timestamp: Date()
                )
            )
            
            // Other user message
            MessageChatBubble(
                message: Message(
                    senderId: UUID(),
                    recipientId: UserManager.shared.getCurrentUser()?.id ?? UUID(),
                    content: "I'm doing well, thanks for asking!",
                    attachments: [],
                    status: .read,
                    timestamp: Date().addingTimeInterval(-300)
                )
            )
        }
        .padding()
    }
}

// Define the bubble shape here to avoid dependencies
struct RoundedBubbleShape: Shape {
    let isCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [
                .topLeft,
                .topRight,
                isCurrentUser ? .bottomLeft : .bottomRight
            ],
            cornerRadii: CGSize(width: 16, height: 16)
        )
        return Path(path.cgPath)
    }
} 