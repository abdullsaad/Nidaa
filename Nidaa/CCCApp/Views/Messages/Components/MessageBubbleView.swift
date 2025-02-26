import SwiftUI
import SwiftData

struct MessageBubbleView: View {
    let message: Message
    @StateObject private var userManager = UserManager.shared
    var onImageTap: ((Attachment) -> Void)? = nil
    
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
            if isFromCurrentUser { Spacer() }
            
            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                if !message.content.isEmpty {
                    Text(message.content)
                        .padding(12)
                        .background(isFromCurrentUser ? Color.blue : Color(.systemGray5))
                        .foregroundColor(isFromCurrentUser ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                if !message.attachments.isEmpty {
                    ForEach(message.attachments) { attachment in
                        if attachment.type == .image {
                            SharedCacheImageView(attachment: attachment)
                                .frame(maxWidth: 200, maxHeight: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .onTapGesture {
                                    onImageTap?(attachment)
                                }
                        }
                    }
                }
                
                // Use explicit text with formatted date string
                Text(Self.dateFormatter.string(from: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            
            if !isFromCurrentUser { Spacer() }
        }
        .padding(.horizontal, 8)
    }
} 