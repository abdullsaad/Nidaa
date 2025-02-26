import SwiftUI
import SwiftData

struct UserProfileActions: View {
    let user: User
    @StateObject private var callCoordinator = CallCoordinator.shared
    
    var body: some View {
        HStack(spacing: 40) {
            Button(action: { startVoiceCall() }) {
                VStack {
                    Image(systemName: "phone.fill")
                        .font(.title2)
                        .padding()
                        .background(Color.green)
                        .clipShape(Circle())
                    
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
                    
                    Text("Video")
                        .font(.caption)
                }
            }
            
            NavigationLink(value: Route.chat(user)) {
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
    }
    
    private func startVoiceCall() {
        callCoordinator.startCall(with: user, type: .audio)
    }
    
    private func startVideoCall() {
        callCoordinator.startCall(with: user, type: .video)
    }
}

struct UserProfileView: View {
    let user: User
    @StateObject private var userManager = UserManager.shared
    @State private var isCurrentUser: Bool = false
    
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
                    
                    if isCurrentUser {
                        Text("(You)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, -4)
                    }
                }
                .padding()
                
                // Contact information
                InfoSection(title: "Contact Information") {
                    InfoRow(icon: "envelope.fill", title: "Email", value: user.email)
                    InfoRow(icon: "phone.fill", title: "Phone", value: user.phoneNumber)
                }
                
                // Professional information
                InfoSection(title: "Professional Information") {
                    InfoRow(icon: "building.2.fill", title: "Department", value: user.department)
                    InfoRow(icon: "stethoscope", title: "Specialty", value: user.specialty)
                    InfoRow(icon: "person.badge.key.fill", title: "Employee ID", value: user.employeeId ?? "N/A")
                }
                
                // Status
                InfoSection(title: "Status") {
                    HStack {
                        Image(systemName: statusIcon)
                            .foregroundColor(statusColor)
                        Text(user.status.rawValue.capitalized)
                            .foregroundColor(statusColor)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                // Certifications
                if !user.certifications.isEmpty {
                    InfoSection(title: "Certifications") {
                        ForEach(user.certifications) { certification in
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.accentColor)
                                Text(certification.name)
                                Spacer()
                                Text(certification.expirationDate, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Check if this is the current user
            if let currentUser = userManager.getCurrentUser() {
                isCurrentUser = (user.id == currentUser.id)
            }
        }
    }
    
    private var statusIcon: String {
        switch user.status {
        case .active: return "circle.fill"
        case .inactive: return "circle.slash"
        case .available: return "checkmark.circle.fill"
        case .busy: return "exclamationmark.circle.fill"
        case .offline: return "minus.circle.fill"
        case .inCall: return "phone.circle.fill"
        case .onCall: return "bell.circle.fill"
        case .onLeave: return "airplane.circle.fill"
        }
    }
    
    private var statusColor: Color {
        switch user.status {
        case .active, .available: return .green
        case .busy, .inCall, .onCall: return .orange
        case .inactive, .offline, .onLeave: return .gray
        }
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 0) {
                content
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}
