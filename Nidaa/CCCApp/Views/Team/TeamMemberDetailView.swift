import SwiftUI
import SwiftData

struct TeamMemberDetailView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var callCoordinator = CallCoordinator.shared
    @State private var showingCallView = false
    @State private var activeCall: Call?
    
    // Get current user ID directly from AuthenticationManager
    private var currentUserId: UUID {
        AuthenticationManager.shared.currentUserId
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile header
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.accentColor)
                    
                    Text(user.fullName)
                        .font(.title)
                        .bold()
                    
                    Text(user.role.rawValue.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Status indicator
                    HStack {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 10, height: 10)
                        
                        Text(user.status.rawValue.capitalized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                // Action buttons
                HStack(spacing: 40) {
                    Button(action: { startVoiceCall() }) {
                        VStack {
                            Image(systemName: "phone.fill")
                                .font(.title2)
                                .padding()
                                .background(Color.green)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                            
                            Text("Call")
                                .font(.caption)
                        }
                    }
                    
                    Button(action: { startVideoCall() }) {
                        VStack {
                            Image(systemName: "video.fill")
                                .font(.title2)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                            
                            Text("Video")
                                .font(.caption)
                        }
                    }
                    
                    NavigationLink(destination: ChatView(otherUser: user)) {
                        VStack {
                            Image(systemName: "message.fill")
                                .font(.title2)
                                .padding()
                                .background(Color.purple)
                                .clipShape(Circle())
                            
                            Text("Message")
                                .font(.caption)
                        }
                    }
                }
                .foregroundColor(.white)
                
                // Contact information
                VStack(alignment: .leading, spacing: 12) {
                    Text("Contact Information")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 0) {
                        InfoRow(icon: "envelope.fill", title: "Email", value: user.email)
                        Divider()
                        InfoRow(icon: "phone.fill", title: "Phone", value: user.phoneNumber)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                
                // Professional information
                VStack(alignment: .leading, spacing: 12) {
                    Text("Professional Information")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 0) {
                        InfoRow(icon: "building.2.fill", title: "Department", value: user.department)
                        Divider()
                        InfoRow(icon: "stethoscope", title: "Specialty", value: user.specialty)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Team Member")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $activeCall) { call in
            ActiveCallView(call: call)
        }
    }
    
    private func startVoiceCall() {
        let call = Call(
            initiatorId: currentUserId,
            recipientId: user.id,
            type: .voice
        )
        activeCall = call
    }
    
    private func startVideoCall() {
        let call = Call(
            initiatorId: currentUserId,
            recipientId: user.id,
            type: .video
        )
        activeCall = call
    }
    
    private var statusColor: Color {
        switch user.status {
        case .active, .available:
            return .green
        case .busy, .inCall, .onCall:
            return .orange
        case .inactive, .offline, .onLeave:
            return .gray
        }
    }
} 