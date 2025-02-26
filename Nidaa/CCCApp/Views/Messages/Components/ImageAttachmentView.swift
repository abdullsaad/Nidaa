import SwiftUI

struct ImageAttachmentView: View {
    let attachment: Attachment
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    )
                    .onAppear {
                        loadImage()
                    }
            }
        }
        .frame(width: 200, height: 200)
    }
    
    private func loadImage() {
        // Try to load from SharedImageCache
        if let imageID = attachment.imageID, 
           let cachedImage = SharedImageCache.shared.getImage(id: imageID) {
            self.image = cachedImage
        }
    }
} 