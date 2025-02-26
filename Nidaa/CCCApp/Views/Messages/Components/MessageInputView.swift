import SwiftUI

struct MessageInputView: View {
    @Binding var text: String
    @Binding var attachments: [Attachment]
    let onSend: () -> Void
    let onAttach: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onAttach) {
                Image(systemName: "paperclip")
                    .foregroundColor(.accentColor)
            }
            
            TextField("Type a message...", text: $text)
                .textFieldStyle(.roundedBorder)
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
            .disabled(text.isEmpty && attachments.isEmpty)
        }
        .padding()
    }
} 