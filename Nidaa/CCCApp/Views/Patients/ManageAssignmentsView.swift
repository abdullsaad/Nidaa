import SwiftUI
import SwiftData

struct ManageAssignmentsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Patient.lastName) private var patients: [Patient]
    @StateObject private var authManager = AuthenticationManager.shared
    
    @State private var selectedPatients: Set<UUID> = []
    @State private var searchText = ""
    
    private var myPatients: [Patient] {
        patients.filter { patient in
            patient.assignedTeam.contains(authManager.currentUserId)
        }
    }
    
    private var filteredPatients: [Patient] {
        myPatients.filter { patient in
            searchText.isEmpty || 
            patient.fullName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedPatients) {
                ForEach(filteredPatients) { patient in
                    PatientRowView(patient: patient)
                        .tag(patient.id)
                }
            }
            .searchable(text: $searchText, prompt: "Search patients")
            .navigationTitle("Manage Assignments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .destructiveAction) {
                    Menu {
                        Button(role: .destructive) {
                            unassignSelected()
                        } label: {
                            Label("Unassign Selected", systemImage: "person.badge.minus")
                        }
                        .disabled(selectedPatients.isEmpty)
                        
                        Button(role: .destructive) {
                            unassignAll()
                        } label: {
                            Label("Unassign All", systemImage: "person.2.slash")
                        }
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    private func unassignSelected() {
        for patientId in selectedPatients {
            if let patient = patients.first(where: { $0.id == patientId }),
               let index = patient.assignedTeam.firstIndex(of: authManager.currentUserId) {
                patient.assignedTeam.remove(at: index)
            }
        }
        try? modelContext.save()
        selectedPatients.removeAll()
    }
    
    private func unassignAll() {
        for patient in myPatients {
            if let index = patient.assignedTeam.firstIndex(of: authManager.currentUserId) {
                patient.assignedTeam.remove(at: index)
            }
        }
        try? modelContext.save()
    }
} 