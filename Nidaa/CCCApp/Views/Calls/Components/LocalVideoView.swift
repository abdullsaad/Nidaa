import SwiftUI

struct LocalVideoView: View {
    let isEnabled: Bool
    
    var body: some View {
        Group {
            if isEnabled {
                Color.gray
            } else {
                Color.black
                    .overlay {
                        Image(systemName: "video.slash")
                            .foregroundColor(.white)
                    }
            }
        }
        .frame(width: 120, height: 160)
        .cornerRadius(12)
    }
} 