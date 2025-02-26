import SwiftUI

struct MessageMetadataView: View {
    let message: Message
    let sender: User?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let sender = sender {
                HStack {
                    Label("From:", systemImage: "person")
                    Text(sender.fullName)
                }
            }
            
            HStack {
                Label("Sent:", systemImage: "clock")
                Text(message.timestamp.formatted())
            }
            
            if let readTimestamp = message.readTimestamp {
                HStack {
                    Label("Read:", systemImage: "checkmark")
                    Text(readTimestamp.formatted())
                }
            }
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
} 