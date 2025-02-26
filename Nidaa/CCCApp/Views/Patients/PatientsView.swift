import SwiftUI
import SwiftData

struct PatientsView: View {
    @Query(sort: \Patient.lastName) private var patients: [Patient]
    @StateObject private var authManager = AuthenticationManager.shared
    @Environment(\.patientViewModel) private var patientViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var showPatientAssignment = false
    @State private var selectedFilter: PatientFilter = .all
    
    // Filter to only show assigned patients
    private var myPatients: [Patient] {
        // Show all patients for demo purposes
        patients
    }
    
    private var filteredPatients: [Patient] {
        myPatients.filter { patient in
            // Apply search filter
            let matchesSearch = searchText.isEmpty || 
                patient.fullName.localizedCaseInsensitiveContains(searchText)
            
            // Apply status filter
            let matchesFilter: Bool = {
                switch selectedFilter {
                case .all: return true
                case .critical: return patient.status == .critical
                case .stable: return patient.status == .stable
                }
            }()
            
            return matchesSearch && matchesFilter
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                PatientFilterView(selectedFilter: $selectedFilter)
                
                if filteredPatients.isEmpty {
                    ContentUnavailableView {
                        Label("No Patients Found", systemImage: "person.fill.questionmark")
                    } description: {
                        Text("There are no patients in the system")
                    }
                } else {
                    List {
                        ForEach(filteredPatients) { patient in
                            NavigationLink(value: patient) {
                                PatientRowView(patient: patient)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    unassignPatient(patient)
                                } label: {
                                    Label("Unassign", systemImage: "person.badge.minus")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                
                // Prominent assignment button
                Button(action: { showPatientAssignment.toggle() }) {
                    HStack {
                        Image(systemName: "person.badge.shield.checkmark")
                        Text("Manage Patient Assignments")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationDestination(for: Patient.self) { patient in
                PatientDetailView(patient: patient)
            }
            .navigationTitle("Patients")
            .searchable(text: $searchText, prompt: "Search patients")
            .sheet(isPresented: $showPatientAssignment) {
                PatientAssignmentView()
            }
            .onAppear {
                patientViewModel.refreshPatients()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RefreshData"))) { _ in
                patientViewModel.refreshPatients()
            }
        }
    }
    
    private func unassignPatient(_ patient: Patient) {
        if let index = patient.assignedTeam.firstIndex(of: authManager.currentUserId) {
            patient.assignedTeam.remove(at: index)
        }
    }
}

enum PatientFilter: String, CaseIterable {
    case all = "All"
    case critical = "Critical"
    case stable = "Stable"
} 