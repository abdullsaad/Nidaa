import SwiftUI
import SwiftData

// Define the Team model if it doesn't exist elsewhere
struct Team: Identifiable {
    let id: UUID
    let name: String
    var members: [UUID]
    var messages: [UUID]
    
    init(id: UUID = UUID(), name: String, members: [UUID] = [], messages: [UUID] = []) {
        self.id = id
        self.name = name
        self.members = members
        self.messages = messages
    }
}

struct TeamChatView: View {
    let patient: Patient
    @Environment(\.modelContext) private var modelContext
    @StateObject private var messageManager = MessageManager.shared
    @StateObject private var authManager = AuthenticationManager.shared
    
    @State private var messageText = ""
    @State private var attachments: [Attachment] = []
    @State private var showingAttachmentPicker = false
    @State private var selectedAttachment: Attachment?
    @State private var showingPreview = false
    
    // Get messages for this team chat
    private var messages: [Message] {
        // Implement message filtering logic here
        []
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            Divider()
            
            TeamMessageInputView(
                text: $messageText,
                attachments: $attachments,
                onSend: sendMessage,
                onAttach: { showingAttachmentPicker = true }
            )
        }
        .navigationTitle("Team Chat")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAttachmentPicker) {
            AttachmentPickerView(selectedAttachments: $attachments)
        }
        .sheet(item: $selectedAttachment) { attachment in
            AttachmentPreview(attachment: attachment)
        }
    }
    
    private func sendMessage() {
        // Check if we have content to send and a valid user ID
        guard !messageText.isEmpty || !attachments.isEmpty else { return }
        
        let currentUserId = authManager.currentUserId
        
        // Create and save the message
        let message = Message(
            senderId: currentUserId,
            recipientId: patient.id,
            content: messageText,
            messageType: .text,
            attachments: attachments
        )
        
        modelContext.insert(message)
        
        // Clear input
        messageText = ""
        attachments = []
    }
}

struct TeamMessageView: View {
    let message: Message
    @Query private var users: [User]
    
    private var sender: User? {
        users.first { $0.id == message.senderId }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Sender name
            if let sender = sender {
                Text(sender.fullName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Message content
            Text(message.content)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            // Timestamp
            Text(formattedTime)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: message.timestamp)
    }
}

struct TeamMemberBubble: View {
    let user: User
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack(alignment: .bottomTrailing) {
                    UserAvatarView(user: user)
                        .frame(width: 50, height: 50)
                    
                    StatusIndicator(status: user.status)
                        .offset(x: 2, y: 2)
                }
                
                Text(user.firstName)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
} 