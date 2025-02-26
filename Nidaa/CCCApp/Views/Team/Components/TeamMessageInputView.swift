import SwiftUI

struct TeamMessageInputView: View {
    @Binding var text: String
    @Binding var attachments: [Attachment]
    let onSend: () -> Void
    let onAttach: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            MessageInputBar(
                text: $text,
                onSend: onSend,
                onAttach: onAttach
            )
            
            if !attachments.isEmpty {
                AttachmentsRow(attachments: $attachments)
            }
        }
    }
}

// Break out the input bar into its own component
private struct MessageInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    let onAttach: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onAttach) {
                Image(systemName: "paperclip")
                    .font(.title3)
                    .foregroundColor(.accentColor)
            }
            
            TextField("Type a message...", text: $text)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.send)
                .onSubmit(onSend)
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(text.isEmpty ? .gray : .accentColor)
            }
            .disabled(text.isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}


