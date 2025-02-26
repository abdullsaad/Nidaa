import SwiftUI

struct CallControlsView: View {
    @Binding var isMuted: Bool
    @Binding var isSpeakerOn: Bool
    @Binding var isVideoEnabled: Bool
    let onEnd: () -> Void
    
    var body: some View {
        HStack(spacing: 40) {
            CallControlButton(
                icon: "speaker.wave.2.fill",
                color: isSpeakerOn ? .accentColor : .gray
            ) {
                isSpeakerOn.toggle()
            }
            
            CallControlButton(
                icon: "mic.slash.fill",
                color: isMuted ? .accentColor : .gray
            ) {
                isMuted.toggle()
            }
            
            CallControlButton(
                icon: "video.slash.fill",
                color: isVideoEnabled ? .gray : .accentColor
            ) {
                isVideoEnabled.toggle()
            }
            
            CallControlButton(
                icon: "phone.down.fill",
                color: .red,
                action: onEnd
            )
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    CallControlsView(
        isMuted: .constant(false),
        isSpeakerOn: .constant(false),
        isVideoEnabled: .constant(false),
        onEnd: {}
    )
} 
