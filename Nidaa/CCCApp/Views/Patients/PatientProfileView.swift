import SwiftUI
import SwiftData

struct PatientProfileView: View {
    let patient: Patient
    @Environment(\.modelContext) private var modelContext
    @State private var showingStatusEditor = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Patient header with basic info
                PatientHeaderView(patient: patient)
                
                // Status update button
                Button(action: {
                    showingStatusEditor = true
                }) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.accentColor)
                        Text("Update Status")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Patient details in tabs
                PatientDetailTabView(patient: patient)
            }
            .padding()
        }
        .navigationTitle("Patient Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingStatusEditor) {
            PersonalStatusEditorView(
                patient: patient,
                currentStatus: nil // You would fetch the current personal status here
            )
        }
    }
    
    private func handleStatusChange(newStatus: PatientStatus) {
        // Update status in the database
        patient.status = newStatus
        
        // Save changes to the database
        try? modelContext.save()
        
        // Show success message (you would implement a toast system)
        print("Patient status updated successfully")
    }
}

struct PatientDetailTabView: View {
    let patient: Patient
    @State private var selectedTab = "Info"
    
    let tabs = ["Info", "Vitals", "Medications", "Team"]
    
    var body: some View {
        VStack {
            // Tab selector
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        Text(tab)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                selectedTab == tab ?
                                    Color.accentColor :
                                    Color.clear
                            )
                            .foregroundColor(
                                selectedTab == tab ?
                                    .white :
                                    .primary
                            )
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.vertical)
            
            // Tab content
            switch selectedTab {
            case "Info":
                PatientInfoTab(patient: patient)
            case "Vitals":
                PatientVitalsTab(patient: patient)
            case "Medications":
                PatientMedicationsTab(patient: patient)
            case "Team":
                PatientTeamTab(patient: patient)
            default:
                Text("Tab not implemented")
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Patient.self, configurations: config)
    
    let patient = Patient(
        firstName: "Fatima",
        lastName: "Al-Ghamdi",
        dateOfBirth: Date(),
        medicalRecordNumber: "MRN-123459",
        wardInfo: Patient.WardInfo(
            floorNumber: 3,
            wardNumber: "3A",
            bedNumber: "302-A"
        ),
        roomNumber: "302-A",
        assignedTeam: [],
        status: .stable,
        chiefComplaint: "Fever and productive cough for 3 days",
        activeProblems: ["Community-acquired pneumonia", "Asthma", "Hypertension"]
    )
    
    return NavigationStack {
        PatientProfileView(patient: patient)
    }
    .modelContainer(container)
} 