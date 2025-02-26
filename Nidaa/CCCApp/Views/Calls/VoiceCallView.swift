import SwiftUI
import SwiftData

struct VoiceCallView: View {
    let call: Call
    @Query private var users: [User]
    
    private var otherUser: User? {
        users.first { $0.id == call.recipientId }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            if let user = otherUser {
                UserAvatarView(user: user)
                    .frame(width: 120, height: 120)
                
                Text(user.fullName)
                    .font(.title)
                
                Text(callStatusText)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Call Controls
            HStack(spacing: 40) {
                CallControlButton(icon: "speaker.wave.2.fill", color: .gray) {
                    // Toggle speaker
                }
                
                CallControlButton(icon: "mic.slash.fill", color: .blue) {
                    // Toggle mute
                }
                
                CallControlButton(icon: "phone.down.fill", color: .red) {
                    CallCoordinator.shared.endCurrentCall()
                }
            }
            .padding(.bottom, 40)
        }
        .padding()
    }
    
    private var callStatusText: String {
        switch call.status {
        case .connecting:
            return "Connecting..."
        case .ringing:
            return "Ringing..."
        case .connected:
            return "Connected"
        case .ended:
            return "Call Ended"
        case .declined:
            return "Call Declined"
        case .missed:
            return "Missed Call"
        case .failed:
            return "Call Failed"
        }
    }
}

struct CallButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(color)
                .clipShape(Circle())
        }
    }
} 