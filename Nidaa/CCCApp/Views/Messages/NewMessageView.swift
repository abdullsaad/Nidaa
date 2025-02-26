import SwiftUI
import SwiftData
import PhotosUI

struct NewMessageView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var messageManager = MessageManager.shared
    @StateObject private var userManager = UserManager.shared
    
    @State private var searchText = ""
    @State private var selectedUser: User?
    @State private var messageText = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // User list
                List {
                    ForEach(filteredUsers) { user in
                        Button {
                            selectedUser = user
                        } label: {
                            UserRow(user: user)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(.plain)
                
                // Message input
                if let selectedUser = selectedUser {
                    VStack(spacing: 0) {
                        Divider()
                        
                        HStack(alignment: .bottom) {
                            TextField("Message to \(selectedUser.firstName)...", text: $messageText, axis: .vertical)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(20)
                                .padding(.leading)
                                .padding(.vertical, 8)
                            
                            Button {
                                sendMessage()
                            } label: {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.accentColor)
                            }
                            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            .padding(.horizontal)
                        }
                    }
                    .background(Color(.systemBackground))
                }
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search users")
            .overlay {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
    }
    
    private var filteredUsers: [User] {
        do {
            // First fetch all users
            let allUsers = try modelContext.fetch(FetchDescriptor<User>(sortBy: [SortDescriptor(\.lastName)]))
            
            // Then filter out the current user manually
            let filteredUsers = allUsers.filter { user in
                if let currentUser = userManager.getCurrentUser() {
                    return user.id != currentUser.id
                }
                return true
            }
            
            // Apply search filter if needed
            if searchText.isEmpty {
                return filteredUsers
            } else {
                return filteredUsers.filter { user in
                    user.fullName.localizedCaseInsensitiveContains(searchText) ||
                    user.department.localizedCaseInsensitiveContains(searchText) ||
                    user.role.rawValue.localizedCaseInsensitiveContains(searchText)
                }
            }
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
            return []
        }
    }
    
    private func sendMessage() {
        guard let selectedUser = selectedUser else { return }
        
        isLoading = true
        
        // Send message
        messageManager.sendMessage(
            to: selectedUser.id,
            content: messageText,
            attachments: []
        )
        
        // Reset and dismiss
        messageText = ""
        isLoading = false
        dismiss()
    }
}

struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Image(systemName: "person.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.accentColor)
            
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.headline)
                
                HStack {
                    Text(user.role.rawValue.capitalized)
                        .font(.subheadline)
                    
                    if !user.department.isEmpty {
                        Text("•")
                        Text(user.department)
                            .font(.subheadline)
                    }
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Status indicator
            Circle()
                .fill(statusColor(for: user.status))
                .frame(width: 10, height: 10)
        }
        .padding(.vertical, 4)
    }
    
    private func statusColor(for status: UserStatus) -> Color {
        switch status {
        case .active, .available:
            return .green
        case .busy, .inCall, .onCall:
            return .orange
        case .inactive, .offline, .onLeave:
            return .gray
        }
    }
}

#Preview {
    NewMessageView()
        .modelContainer(for: [User.self, Message.self], inMemory: true)
} 
