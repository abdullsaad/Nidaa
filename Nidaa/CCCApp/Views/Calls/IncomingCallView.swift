import SwiftUI
import SwiftData

struct IncomingCallView: View {
    let call: Call
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]
    
    private var caller: User? {
        users.first { $0.id == call.initiatorId }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            if let caller = caller {
                UserAvatarView(user: caller)
                    .frame(width: 120, height: 120)
                
                Text(caller.fullName)
                    .font(.title)
                
                Text("Incoming \(call.type.rawValue) Call")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 60) {
                CallActionButton(
                    icon: "phone.down.fill",
                    color: .red
                ) {
                    CallCoordinator.shared.rejectIncomingCall()
                    dismiss()
                }
                
                CallActionButton(
                    icon: "phone.fill",
                    color: .green
                ) {
                    CallCoordinator.shared.acceptIncomingCall()
                    dismiss()
                }
            }
            .padding(.bottom, 40)
        }
        .padding()
    }
}

struct CallActionButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
                .background(color)
                .clipShape(Circle())
        }
    }
} 