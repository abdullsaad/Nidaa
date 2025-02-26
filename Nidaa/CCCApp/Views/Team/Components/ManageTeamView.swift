import SwiftUI
import SwiftData

struct ManageTeamView: View {
    let patient: Patient
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRole: UserRole?
    @State private var searchText = ""
    
    @Query private var users: [User]
    
    var filteredUsers: [User] {
        users.filter { user in
            let matchesSearch = searchText.isEmpty || 
                user.fullName.localizedCaseInsensitiveContains(searchText)
            let matchesRole = selectedRole == nil || user.role == selectedRole
            return matchesSearch && matchesRole
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Role Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(
                            title: "All",
                            isSelected: selectedRole == nil,
                            action: { selectedRole = nil }
                        )
                        
                        ForEach(UserRole.allCases, id: \.self) { role in
                            FilterChip(
                                title: role.rawValue.capitalized,
                                isSelected: selectedRole == role,
                                action: { selectedRole = role }
                            )
                        }
                    }
                    .padding()
                }
                
                List {
                    ForEach(filteredUsers) { user in
                        UserSelectionRow(
                            user: user,
                            isSelected: patient.assignedTeam.contains(user.id),
                            action: { toggleUserSelection(user) }
                        )
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Manage Team")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search team members")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func toggleUserSelection(_ user: User) {
        if patient.assignedTeam.contains(user.id) {
            patient.assignedTeam.removeAll { $0 == user.id }
        } else {
            patient.assignedTeam.append(user.id)
        }
    }
}

// Helper Views


struct UserSelectionRow: View {
    let user: User
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                UserAvatarView(user: user)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.fullName)
                        .font(.headline)
                    
                    Text(user.role.rawValue.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .foregroundColor(.primary)
    }
} 
