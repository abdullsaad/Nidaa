import SwiftUI
import PhotosUI

struct AttachmentPickerView: View {
    @Binding var selectedAttachments: [Attachment]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Photos") {
                    PhotosPicker(selection: $selectedPhotos) {
                        Label("Choose Photos", systemImage: "photo.on.rectangle")
                    }
                }
                
                Section("Files") {
                    Button {
                        // TODO: Implement document picker
                    } label: {
                        Label("Choose Files", systemImage: "doc")
                    }
                }
            }
            .navigationTitle("Add Attachments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
} 