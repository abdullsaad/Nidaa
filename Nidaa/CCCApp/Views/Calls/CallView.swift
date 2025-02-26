import SwiftUI
import AVKit

struct CallView: View {
    let recipient: User
    let type: CallType
    @Environment(\.dismiss) private var dismiss
    @State private var callDuration: TimeInterval = 0
    @State private var timer: Timer?
    @State private var isMuted = false
    @State private var isSpeakerOn = false
    @State private var isVideoEnabled = true
    
    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            
            VStack {
                // Call status
                Text(type == .voice ? "Voice Call" : "Video Call")
                    .font(.headline)
                    .foregroundColor(.white)
                
                if type == .video {
                    // Video preview (demo)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        }
                } else {
                    // Voice call UI
                    VStack {
                        UserAvatarView(user: recipient)
                            .frame(width: 120, height: 120)
                        Text(recipient.fullName)
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 40)
                }
                
                // Call duration
                Text(formatDuration(callDuration))
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                
                Spacer()
                
                // Call controls
                HStack(spacing: 40) {
                    CallControlButton(
                        icon: "speaker.wave.2.fill",
                        color: isSpeakerOn ? .white : .gray
                    ) {
                        isSpeakerOn.toggle()
                    }
                    
                    CallControlButton(
                        icon: "mic.slash.fill",
                        color: isMuted ? .white : .gray
                    ) {
                        isMuted.toggle()
                    }
                    
                    if type == .video {
                        CallControlButton(
                            icon: "video.slash.fill",
                            color: isVideoEnabled ? .gray : .white
                        ) {
                            isVideoEnabled.toggle()
                        }
                    }
                    
                    CallControlButton(
                        icon: "phone.down.fill",
                        color: .red
                    ) {
                        endCall()
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            callDuration += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func endCall() {
        stopTimer()
        dismiss()
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct UserCallInfoView: View {
    let user: User
    let call: Call
    let duration: TimeInterval
    
    var body: some View {
        VStack(spacing: 16) {
            UserAvatarView(user: user)
                .frame(width: 100, height: 100)
            
            Text(user.fullName)
                .font(.title)
                .foregroundColor(.white)
            
            Text(callStatusText)
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Call Duration: \(duration.formattedTime)")
                .font(.caption)
                .foregroundColor(.gray)
        }
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

struct PermissionRequiredView: View {
    enum PermissionType {
        case camera
        case microphone
        
        var icon: String {
            switch self {
            case .camera: return "video.slash"
            case .microphone: return "mic.slash"
            }
        }
        
        var message: String {
            switch self {
            case .camera: return "Camera access required"
            case .microphone: return "Microphone access required"
            }
        }
    }
    
    let type: PermissionType
    let action: () async -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: type.icon)
                .font(.system(size: 50))
                .foregroundColor(.white)
            
            Text(type.message)
                .font(.headline)
                .foregroundColor(.white)
            
            Button(action: { Task { await action() } }) {
                Text("Grant Access")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(.blue)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
} 

