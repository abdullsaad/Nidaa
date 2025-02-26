import SwiftUI
import SwiftData

struct CallContentView: View {
    let call: Call
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]
    
    @State private var duration: TimeInterval = 0
    @State private var isMuted = false
    @State private var isSpeakerOn = false
    @State private var isVideoEnabled = false
    
    var body: some View {
        VStack {
            if call.type == .video {
                VideoCallView(
                    isLocalVideoEnabled: isVideoEnabled,
                    isRemoteVideoEnabled: true
                )
            } else {
                VoiceCallView(call: call)
            }
            
            CallControlsView(
                isMuted: $isMuted,
                isSpeakerOn: $isSpeakerOn,
                isVideoEnabled: $isVideoEnabled,
                onEnd: { dismiss() }
            )
        }
    }
} 