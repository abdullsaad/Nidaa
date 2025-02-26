import SwiftUI

struct ChatNavigationHeader: View {
    let recipient: User
    let onVoiceCall: () -> Void
    let onVideoCall: () -> Void
    @State private var navigateToProfile = false
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: { navigateToProfile = true }) {
                HStack {
                    UserAvatarView(user: recipient)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(recipient.fullName)
                            .font(.headline)
                        
                        HStack {
                            StatusIndicator(status: recipient.status)
                            Text(recipient.status.rawValue.capitalized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .foregroundColor(.primary) // Make it look less like a button
            }
            
            Spacer()
            
            Button(action: onVoiceCall) {
                Image(systemName: "phone")
                    .font(.title3)
                    .foregroundColor(.accentColor)
            }
            
            Button(action: onVideoCall) {
                Image(systemName: "video")
                    .font(.title3)
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .navigationDestination(isPresented: $navigateToProfile) {
            ProfileView(user: recipient)
        }
    }
} 