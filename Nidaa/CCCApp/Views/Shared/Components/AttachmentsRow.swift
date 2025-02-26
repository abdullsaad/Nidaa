import SwiftUI

struct AttachmentsRow: View {
    @Binding var attachments: [Attachment]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(attachments) { attachment in
                    AttachmentPreviewThumbnail(attachment: attachment)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 60)
        .background(Color(.systemBackground))
    }
} 