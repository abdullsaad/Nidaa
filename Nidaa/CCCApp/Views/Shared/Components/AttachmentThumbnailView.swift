import SwiftUI
import QuickLook

struct AttachmentThumbnailView: View {
    let attachment: Attachment
    @State private var thumbnail: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if let thumbnail = thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                attachmentIcon
            }
            
            Text(attachment.url.lastPathComponent)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .frame(width: 80)
        .task {
            await loadThumbnail()
        }
    }
    
    private var attachmentIcon: some View {
        Image(systemName: attachment.type.icon)
            .font(.largeTitle)
            .foregroundColor(.accentColor)
            .frame(width: 80, height: 80)
    }
    
    private func loadThumbnail() async {
        guard thumbnail == nil else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        switch attachment.type {
        case .image:
            if let data = try? Data(contentsOf: attachment.url),
               let image = UIImage(data: data) {
                thumbnail = image
            }
        case .video:
            if let thumbnail = try? await VideoThumbnailGenerator.generateThumbnail(for: attachment.url) {
                self.thumbnail = thumbnail
            }
        default:
            break
        }
    }
} 