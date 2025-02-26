import SwiftUI

struct VideoCallView: View {
    // Temporarily remove CallManager dependency
    let isLocalVideoEnabled: Bool
    let isRemoteVideoEnabled: Bool
    
    var body: some View {
        ZStack {
            // Remote video placeholder
            Color.black
                .overlay {
                    if !isRemoteVideoEnabled {
                        Image(systemName: "video.slash")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                }
                .ignoresSafeArea()
            
            // Local video preview
            if isLocalVideoEnabled {
                LocalVideoView(isEnabled: true)
                    .frame(width: 120, height: 160)
                    .cornerRadius(12)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
        }
    }
}

#Preview {
    VideoCallView(
        isLocalVideoEnabled: true,
        isRemoteVideoEnabled: true
    )
} 