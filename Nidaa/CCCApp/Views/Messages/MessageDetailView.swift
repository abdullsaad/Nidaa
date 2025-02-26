import SwiftUI
import SwiftData

struct MessageDetailView: View {
    let message: Message
    @Environment(\.modelContext) private var modelContext
    @StateObject private var messageManager = MessageManager.shared
    @State private var replyText = ""
    @State private var attachments: [Attachment] = []
    @State private var showingAttachments = false
    @State private var selectedAttachment: Attachment?
    
    @Query private var users: [User]
    @Query private var patients: [Patient]
    
    private var sender: User? {
        users.first { $0.id == message.senderId }
    }
    
    private var relatedPatient: Patient? {
        guard let patientId = message.patientId else { return nil }
        return patients.first { $0.id == patientId }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Message content
                Text(message.content)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                // Attachments if any
                if !message.attachments.isEmpty {
                    AttachmentsView(
                        attachments: message.attachments,
                        selectedAttachment: .constant(nil),
                        showingPreview: .constant(false)
                    )
                }
                
                // Related patient info if available
                if let patient = relatedPatient {
                    NavigationLink(value: patient) {
                        PatientInfoCard(patient: patient)
                    }
                }
                
                // Message metadata
                MessageMetadataView(message: message, sender: sender)
            }
            .padding()
        }
        .navigationTitle("Message Details")
    }
    
    private func markAsRead() {
        if message.status != .read {
            message.status = .read
            message.readTimestamp = Date()
            try? modelContext.save()
        }
    }
    
    private func sendReply() {
        guard !replyText.isEmpty else { return }
        
        messageManager.sendMessage(
            to: message.senderId,
            content: replyText,
            attachments: attachments
        )
        
        replyText = ""
        attachments = []
    }
    
    private func handleAttachment() {
        // Implement attachment handling
    }
}

struct MessageHeaderView: View {
    let message: Message
    @Query private var users: [User]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let sender = users.first(where: { $0.id == message.senderId }) {
                    UserAvatarView(user: sender)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text(sender.fullName)
                            .font(.headline)
                        
                        Text(sender.role.rawValue.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Text(message.timestamp.formatted(.relative(presentation: .named)))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if message.messageType == .broadcast {
                Label("Broadcast Message", systemImage: "broadcast.and.wifipulse")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct PatientContextView: View {
    let patient: Patient
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Related Patient")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(patient.fullName)
                    .font(.headline)
                
                Text("Room \(patient.roomNumber ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct AlertInfoView: View {
    let message: Message
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            
            VStack(alignment: .leading) {
                Text("Alert Message")
                    .font(.headline)
                
                Text("Requires immediate attention")
                    .font(.caption)
            }
            .foregroundColor(.red)
            
            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
