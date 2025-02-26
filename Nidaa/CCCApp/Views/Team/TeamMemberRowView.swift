import SwiftUI

struct TeamMemberRowView: View {
    let user: User
    
    var body: some View {
        HStack {
            UserAvatarView(user: user)
                .frame(width: 40, height: 40)
            
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
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
} 
