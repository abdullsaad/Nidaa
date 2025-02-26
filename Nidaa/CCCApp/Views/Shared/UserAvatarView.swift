import SwiftUI

struct UserAvatarView: View {
    let user: User
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(.systemGray5))
            
            Text(initials)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.accentColor)
        }
    }
    
    private var initials: String {
        let firstInitial = user.firstName.prefix(1)
        let lastInitial = user.lastName.prefix(1)
        return "\(firstInitial)\(lastInitial)"
    }
} 