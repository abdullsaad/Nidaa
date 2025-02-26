import SwiftUI
import QuickLook

struct AttachmentsView: View {
    let attachments: [Attachment]
    @Binding var selectedAttachment: Attachment?
    @Binding var showingPreview: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(attachments) { attachment in
                    AttachmentPreviewThumbnail(attachment: attachment)
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


// Then create a specific view for messages that uses the shared AttachmentsView


#Preview {
    AttachmentsView(
        attachments: [
            Attachment(
                type: .image,
                url: URL(string: "test.jpg")!,
                name: "Test Image",
                size: 1024,
                mimeType: "image/jpeg"
            ),
            Attachment(
                type: .document,
                url: URL(string: "test.pdf")!,
                name: "Test Document",
                size: 2048,
                mimeType: "application/pdf"
            ),
            Attachment(
                type: .video,
                url: URL(string: "test.mp4")!,
                name: "Test Video",
                size: 4096,
                mimeType: "video/mp4"
            )
        ],
        selectedAttachment: .constant(nil),
        showingPreview: .constant(false)
    )
} 
