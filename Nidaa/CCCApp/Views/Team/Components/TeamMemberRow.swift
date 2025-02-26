import SwiftUI

struct TeamMemberRow: View {
    let user: User
    
    var body: some View {
        HStack {
            UserAvatarView(user: user)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.headline)
                
                HStack {
                    StatusIndicator(status: user.status)
                    Text(user.role.rawValue.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
} 