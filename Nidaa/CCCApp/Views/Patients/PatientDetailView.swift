import SwiftUI
import SwiftData

struct PatientDetailView: View {
    let patient: Patient
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State private var selectedTab = "Info"
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var showingStatusEditor = false
    
    // Query for personal status
    @Query private var personalStatuses: [PersonalizedPatientStatus]
    
    let tabs = ["Info", "Vitals", "Medications", "Team"]
    
    private var myPersonalStatus: PersonalizedPatientStatus? {
        personalStatuses.first { status in
            status.patientId == patient.id && 
            status.userId == authManager.currentUserId
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Patient Header
            PatientHeaderView(patient: patient)
            
            // Personal Status Section (only show if patient is assigned to current user)
            if patient.assignedTeam.contains(authManager.currentUserId) {
                HStack {
                    Label("My Status View:", systemImage: "person.fill.viewfinder")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button(action: { showingStatusEditor = true }) {
                        HStack {
                            Circle()
                                .fill(myPersonalStatus?.status.statusColor ?? .gray)
                                .frame(width: 8, height: 8)
                            Text(myPersonalStatus?.status.rawValue.capitalized ?? "Set Status")
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    }
                }
                .padding()
            }
            
            // Tab Picker
            Picker("View", selection: $selectedTab) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Tab Content
            TabView(selection: $selectedTab) {
                PatientInfoTab(patient: patient)
                    .tag("Info")
                
                PatientVitalsTab(patient: patient)
                    .tag("Vitals")
                
                PatientMedicationsTab(patient: patient)
                    .tag("Medications")
                
                PatientTeamTab(patient: patient)
                    .tag("Team")
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingStatusEditor) {
            PersonalStatusEditorView(patient: patient, currentStatus: myPersonalStatus)
        }
    }
}

struct AlertRowView: View {
    let alert: Alert
    
    var body: some View {
        HStack {
            Circle()
                .fill(alertColor)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.message)
                    .font(.subheadline)
                
                Text(formattedTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var alertColor: Color {
        switch alert.type {
        case .critical: return .red
        case .urgent: return .orange
        case .normal: return .blue
        case .info: return .gray
        }
    }
    
    private var formattedTime: String {
        alert.timestamp.formatted(date: .numeric, time: .shortened)
    }
}


// Add these to PatientStatus
extension PatientStatus {
    var color: Color {
        switch self {
        case .stable: return .green
        case .critical: return .red
        case .serious: return .orange
        case .fair: return .yellow
        case .discharged: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .stable: return "checkmark.circle.fill"
        case .critical: return "exclamationmark.triangle.fill"
        case .serious: return "exclamationmark.circle.fill"
        case .fair: return "arrow.up.circle.fill"
        case .discharged: return "house.fill"
        }
    }
} 
