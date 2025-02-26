import SwiftUI
import SwiftData

struct MessagesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Message.timestamp, order: .reverse) private var messages: [Message]
    @Query private var users: [User]
    @StateObject private var messageManager = MessageManager.shared
    @StateObject private var authManager = AuthenticationManager.shared
    
    @State private var selectedUser: User?
    @State private var searchText = ""
    @State private var showingNewMessage = false
    
    // Only show users with existing conversations, sorted by most recent message
    private var activeConversations: [User] {
        // First, get all users with conversations
        users.filter { user in
            // Don't show current user
            guard user.id != authManager.currentUserId else { return false }
            
            // Check if there are any messages between these users
            return messages.contains { message in
                (message.senderId == user.id && message.recipientId == authManager.currentUserId) ||
                (message.senderId == authManager.currentUserId && message.recipientId == user.id)
            }
        }
    }
    
    private func lastMessage(with user: User) -> Message? {
        messages.first { message in
            (message.senderId == user.id && message.recipientId == authManager.currentUserId) ||
            (message.senderId == authManager.currentUserId && message.recipientId == user.id)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activeConversations) { user in
                    NavigationLink(value: user) {
                        ConversationRow(user: user, lastMessage: lastMessage(with: user))
                    }
                }
            }
            .navigationTitle("Messages")
            .navigationDestination(for: User.self) { user in
                ChatView(otherUser: user)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingNewMessage = true }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showingNewMessage) {
                NewMessageView()
            }
        }
    }
}

// Break out the ConversationRow into a separate component
struct ConversationRow: View {
    let user: User
    let lastMessage: Message?
    
    var body: some View {
        HStack {
            UserAvatarView(user: user)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.headline)
                
                if let message = lastMessage {
                    Text(message.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if let timestamp = lastMessage?.timestamp {
                Text(timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}



