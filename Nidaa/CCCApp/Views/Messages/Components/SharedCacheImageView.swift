import SwiftUI

struct SharedCacheImageView: View {
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
            return
        }
        
        // If that fails, try to extract ID from URL
        if let urlString = attachment.url.absoluteString.components(separatedBy: "://").last,
           let extractedImage = SharedImageCache.shared.getImage(id: urlString) {
            self.image = extractedImage
            return
        }
        
        // Last resort: try to load directly from URL
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: attachment.url)
                if let loadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = loadedImage
                    }
                }
            } catch {
                print("Failed to load image from URL: \(error.localizedDescription)")
            }
        }
    }
} 