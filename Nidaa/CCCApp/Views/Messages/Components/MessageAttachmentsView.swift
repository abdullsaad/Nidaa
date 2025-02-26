import SwiftUI
import QuickLook

struct MessageAttachmentsView: View {
    let attachments: [Attachment]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(attachments) { attachment in
                    AttachmentThumbnailView(attachment: attachment)
                }
            }
            .padding(.horizontal)
        }
    }
}
