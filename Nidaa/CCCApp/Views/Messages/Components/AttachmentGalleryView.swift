import SwiftUI
import QuickLook

struct AttachmentGalleryView: View {
    let attachments: [Attachment]
    @Binding var selectedAttachment: Attachment?
    @Binding var showingPreview: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(attachments) { attachment in
                    AttachmentThumbnailView(attachment: attachment)
                        .onTapGesture {
                            selectedAttachment = attachment
                            showingPreview = true
                        }
                }
            }
            .padding(.horizontal)
        }
    }
} 