import SwiftUI

struct VideoPreviewView: View {
    let isEnabled: Bool
    
    var body: some View {
        Group {
            if isEnabled {
                Color.gray
            } else {
                Color.black
                    .overlay {
                        Image(systemName: "video.slash")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
            }
        }
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 5)
    }
}

#Preview {
    VideoPreviewView(isEnabled: true)
} 
