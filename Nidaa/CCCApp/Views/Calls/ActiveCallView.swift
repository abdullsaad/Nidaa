import SwiftUI
import SwiftData

struct ActiveCallView: View {
    let call: Call
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]
    
    @State private var isMuted = false
    @State private var isSpeakerOn = false
    @State private var isVideoEnabled = true
    @State private var duration: TimeInterval = 0
    @State private var timer: Timer?
    
    private var otherUser: User? {
        users.first { $0.id == call.recipientId }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if call.type == .video {
                    VideoCallView(
                        isLocalVideoEnabled: isVideoEnabled,
                        isRemoteVideoEnabled: true
                    )
                } else {
                    if let user = otherUser {
                        VStack(spacing: 20) {
                            UserAvatarView(user: user)
                                .frame(width: 120, height: 120)
                            
                            Text(user.fullName)
                                .font(.title2)
                            
                            Text(duration.formattedTime)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 60)
                    }
                }
                
                Spacer()
                
                CallControlsView(
                    isMuted: $isMuted,
                    isSpeakerOn: $isSpeakerOn,
                    isVideoEnabled: $isVideoEnabled,
                    onEnd: { dismiss() }
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(callStatusText)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
        }
    }
    
    private var callStatusText: String {
        switch call.status {
        case .connecting: return "Connecting..."
        case .ringing: return "Ringing..."
        case .connected: return "Connected"
        case .ended: return "Call Ended"
        case .declined: return "Call Declined"
        case .missed: return "Missed Call"
        case .failed: return "Call Failed"
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            duration += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
} 