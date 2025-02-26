import SwiftUI
import SwiftData

struct ProfileView: View {
    let user: User
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ProfileViewModel
    @State private var showMyPatientsAssignment = false
    @StateObject private var authManager = AuthenticationManager.shared
    
    init(user: User) {
        self.user = user
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        List {
            Section {
                ProfileHeaderView(user: user)
            }
            
            Section("Contact Information") {
                ContactInfoView(user: user)
            }
            
            Section("Work Information") {
                ProfessionalInfoView(user: user)
            }
            
            if !user.certifications.isEmpty {
                Section("Certifications") {
                    CertificationsView(certifications: user.certifications)
                }
            }
            
            if user.id == authManager.currentUserId {
                Section {
                    Button {
                        showMyPatientsAssignment.toggle()
                    } label: {
                        Label("Assign My Patients", systemImage: "person.badge.plus")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .sheet(isPresented: $showMyPatientsAssignment) {
                    MyPatientsAssignmentView()
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Supporting Views
struct ProfileHeaderView: View {
    let user: User
    
    var body: some View {
        HStack {
            UserAvatarView(user: user)
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.title2)
                    .bold()
                
                HStack {
                    StatusIndicator(status: user.status)
                    Text(user.status.rawValue.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct ContactInfoView: View {
    let user: User
    
    var body: some View {
        ProfileField(title: "Email", value: user.email)
        ProfileField(title: "Phone", value: user.phoneNumber)
    }
}

struct ProfessionalInfoView: View {
    let user: User
    
    var body: some View {
        ProfileField(title: "Department", value: user.department)
        ProfileField(title: "Role", value: user.role.rawValue.capitalized)
        if let employeeId = user.employeeId {
            ProfileField(title: "Employee ID", value: employeeId)
        }
    }
}

struct CertificationsView: View {
    let certifications: [Certification]
    
    var body: some View {
        ForEach(certifications) { certification in
            VStack(alignment: .leading) {
                Text(certification.name)
                    .font(.headline)
                Text("Expires: \(certification.expirationDate.formatted(date: .long, time: .omitted))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
} 
