import SwiftUI
import SwiftData

struct MessageRowView: View {
    let message: Message
    @Query private var users: [User]
    
    private var sender: User? {
        users.first { $0.id == message.senderId }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let sender = sender {
                UserAvatarView(user: sender)
                    .frame(width: 40, height: 40)
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let sender = sender {
                    Text(sender.fullName)
                        .font(.headline)
                }
                
                Text(message.content)
                    .font(.body)
                
                if !message.attachments.isEmpty {
                    AttachmentGalleryView(
                        attachments: message.attachments,
                        selectedAttachment: .constant(nil),
                        showingPreview: .constant(false)
                    )
                }
                
                Text(message.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if message.isRead {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
} 
