import SwiftUI

struct AttachmentPreviewThumbnail: View {
    let attachment: Attachment
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: attachment.type.icon)
                .font(.title)
                .foregroundColor(.accentColor)
                .frame(width: 60, height: 60)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Text(attachment.name)
                .font(.caption)
                .lineLimit(1)
        }
    }
} 