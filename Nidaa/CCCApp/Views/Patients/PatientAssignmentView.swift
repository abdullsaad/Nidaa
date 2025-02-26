import SwiftUI
import SwiftData

struct PatientAssignmentView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Patient.wardInfo.wardNumber) private var allPatients: [Patient]
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var searchText = ""
    
    // Debug print to check patients
    private func debugPrintPatients() {
        print("Total patients in database: \(allPatients.count)")
        print("Patients by ward: \(Dictionary(grouping: allPatients) { $0.wardInfo.wardNumber })")
    }
    
    private var patientsByUnit: [String: [Patient]] {
        let units = ["ICU", "3A", "3B", "4A", "4B"]
        var result: [String: [Patient]] = [:]
        
        // Initialize empty arrays for each unit
        for unit in units {
            result[unit] = []
        }
        
        // Add patients to their respective units
        for patient in filteredPatients {
            let ward = patient.wardInfo.wardNumber
            result[ward, default: []].append(patient)
        }
        
        return result
    }
    
    private var filteredPatients: [Patient] {
        if searchText.isEmpty {
            return allPatients
        } else {
            return allPatients.filter { patient in
                patient.fullName.localizedCaseInsensitiveContains(searchText) ||
                patient.medicalRecordNumber.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(patientsByUnit.keys.sorted()), id: \.self) { unit in
                    if let patients = patientsByUnit[unit], !patients.isEmpty {
                        Section("Unit \(unit)") {
                            ForEach(patients) { patient in
                                PatientAssignmentRow(
                                    patient: patient,
                                    isAssigned: patient.assignedTeam.contains(authManager.currentUserId),
                                    toggleAssignment: { toggleAssignment(for: patient) }
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Assign Patients")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search patients")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Assign All") {
                        assignAllPatients()
                    }
                }
            }
            .onAppear {
                debugPrintPatients()
            }
        }
    }
    
    private func toggleAssignment(for patient: Patient) {
        if patient.assignedTeam.contains(authManager.currentUserId) {
            // Remove assignment
            if let index = patient.assignedTeam.firstIndex(of: authManager.currentUserId) {
                patient.assignedTeam.remove(at: index)
            }
        } else {
            // Add assignment
            patient.assignedTeam.append(authManager.currentUserId)
        }
        
        // Save changes
        try? modelContext.save()
    }
    
    private func assignAllPatients() {
        for patient in allPatients {
            if !patient.assignedTeam.contains(authManager.currentUserId) {
                patient.assignedTeam.append(authManager.currentUserId)
            }
        }
        
        // Save changes
        try? modelContext.save()
    }
}

struct PatientAssignmentRow: View {
    let patient: Patient
    let isAssigned: Bool
    let toggleAssignment: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(patient.fullName)
                    .font(.headline)
                
                Text("Room \(patient.roomNumber ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: toggleAssignment) {
                Image(systemName: isAssigned ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isAssigned ? .accentColor : .gray)
                    .font(.title2)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleAssignment()
        }
    }
}

#Preview {
    PatientAssignmentView()
        .modelContainer(for: Patient.self, inMemory: true)
} 