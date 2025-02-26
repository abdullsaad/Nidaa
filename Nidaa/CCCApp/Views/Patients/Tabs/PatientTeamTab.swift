import SwiftUI
import SwiftData

struct PatientTeamTab: View {
    let patient: Patient
    @Query private var users: [User]
    
    private var teamMembers: [User] {
        users.filter { patient.assignedTeam.contains($0.id) }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if teamMembers.isEmpty {
                    ContentUnavailableView(
                        "No Team Members",
                        systemImage: "person.2.slash",
                        description: Text("This patient has no assigned team members")
                    )
                } else {
                    ForEach(teamMembers) { user in
                        NavigationLink(destination: TeamMemberDetailView(user: user)) {
                            TeamMemberCard(user: user)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
        }
    }
}

struct TeamMemberCard: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            UserAvatarView(user: user)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(user.role.rawValue.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if !user.specialty.isEmpty {
                    Text(user.specialty)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
} 
