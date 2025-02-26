import SwiftUI
import SwiftData

struct PatientProfilePage: View {
    let patient: Patient
    @Environment(\.modelContext) private var modelContext
    @Environment(\.patientViewModel) private var patientViewModel
    @State private var showingStatusEditor = false
    @State private var myPersonalStatus: PersonalizedPatientStatus?
    @StateObject private var authManager = AuthenticationManager.shared
    
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
                currentStatus: myPersonalStatus
            )
        }
        .onAppear {
            fetchPersonalStatus()
        }
        .onChange(of: patient.status) { oldValue, newValue in
            // When patient status changes, update in the patient list
            patientViewModel.updatePatientInList(patient)
        }
    }
    
    private func fetchPersonalStatus() {
        // Get the IDs we need to match
        let patientId = patient.id
        let userId = authManager.currentUserId
        
        do {
            // Fetch all personal statuses without a predicate
            let descriptor = FetchDescriptor<PersonalizedPatientStatus>()
            let allStatuses = try modelContext.fetch(descriptor)
            
            // Filter in memory using standard Swift filtering
            myPersonalStatus = allStatuses.first { status in
                status.patientId == patientId && status.userId == userId
            }
            
            if myPersonalStatus != nil {
                print("Found personal status for patient")
            } else {
                print("No personal status found for patient")
            }
        } catch {
            print("Error fetching personal status: \(error.localizedDescription)")
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
        PatientProfilePage(patient: patient)
    }
    .modelContainer(container)
} 