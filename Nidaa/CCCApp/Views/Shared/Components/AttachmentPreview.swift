import SwiftUI
import AVKit
import QuickLook

struct AttachmentPreview: View {
    let attachment: Attachment
    @Environment(\.dismiss) private var dismiss
    @State private var previewURL: URL?
    
    var body: some View {
        NavigationStack {
            Group {
                switch attachment.type {
                case .image:
                    AsyncImage(url: attachment.url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                case .document:
                    if let url = previewURL {
                        QuickLookPreview(url: url)
                    } else {
                        ProgressView()
                            .task {
                                previewURL = attachment.url
                            }
                    }
                case .video:
                    VideoPlayer(player: AVPlayer(url: attachment.url))
                case .audio:
                    AudioPlayerView(url: attachment.url)
                }
            }
            .navigationTitle(attachment.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 