import SwiftUI
import SwiftData

struct MyPatientsAssignmentView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Patient.wardInfo.floorNumber) private var patients: [Patient]
    
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var selectedPatients: Set<UUID> = []
    @State private var searchText = ""
    
    // Group patients by unit
    private var patientsByUnit: [String: [Patient]] {
        Dictionary(grouping: patients) { patient in
            patient.wardInfo.wardNumber
        }
    }
    
    // Available units
    private var units: [String] {
        Array(patientsByUnit.keys).sorted()
    }
    
    // Filter patients by search and assignment status
    private func availablePatientsInUnit(_ unit: String) -> [Patient] {
        let unitPatients = patientsByUnit[unit] ?? []
        let searchTerm = searchText.lowercased()
        
        return unitPatients.filter { patient in
            // Only show patients not already assigned to current user
            !patient.assignedTeam.contains(authManager.currentUserId) &&
            // Filter by search term if any
            (searchTerm.isEmpty ||
             patient.fullName.lowercased().contains(searchTerm) ||
             patient.medicalRecordNumber.lowercased().contains(searchTerm))
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Search bar for MRN or name
                Section {
                    TextField("Search by name or MRN", text: $searchText)
                }
                
                // Units and their patients
                ForEach(units, id: \.self) { unit in
                    Section {
                        UnitHeader(
                            unit: unit,
                            isSelected: isEntireUnitSelected(unit),
                            onToggle: { toggleUnit(unit) }
                        )
                        
                        let availablePatients = availablePatientsInUnit(unit)
                        
                        if availablePatients.isEmpty {
                            Text("No available patients")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(availablePatients) { patient in
                                PatientRow(
                                    patient: patient,
                                    isSelected: selectedPatients.contains(patient.id),
                                    onToggle: { togglePatient(patient) }
                                )
                            }
                        }
                    } header: {
                        Text("Unit \(unit)")
                    } footer: {
                        let count = availablePatientsInUnit(unit).count
                        Text("\(count) patient\(count == 1 ? "" : "s") available")
                    }
                }
            }
            .navigationTitle("Assign My Patients")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Assign (\(selectedPatients.count))") {
                        assignSelectedPatients()
                    }
                    .disabled(selectedPatients.isEmpty)
                }
            }
        }
    }
    
    private func isEntireUnitSelected(_ unit: String) -> Bool {
        let availablePatients = availablePatientsInUnit(unit)
        return !availablePatients.isEmpty && availablePatients.allSatisfy { selectedPatients.contains($0.id) }
    }
    
    private func toggleUnit(_ unit: String) {
        let availablePatients = availablePatientsInUnit(unit)
        
        if isEntireUnitSelected(unit) {
            // Deselect all patients in unit
            availablePatients.forEach { patient in
                selectedPatients.remove(patient.id)
            }
        } else {
            // Select all available patients in unit
            availablePatients.forEach { patient in
                selectedPatients.insert(patient.id)
            }
        }
    }
    
    private func togglePatient(_ patient: Patient) {
        if selectedPatients.contains(patient.id) {
            selectedPatients.remove(patient.id)
        } else {
            selectedPatients.insert(patient.id)
        }
    }
    
    private func assignSelectedPatients() {
        for patientId in selectedPatients {
            if let patient = patients.first(where: { $0.id == patientId }) {
                patient.assignedTeam.append(authManager.currentUserId)
            }
        }
        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Supporting Views
struct UnitHeader: View {
    let unit: String
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack {
                Text("Select All Unit \(unit)")
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .buttonStyle(.borderless)
    }
}

struct PatientRow: View {
    let patient: Patient
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(patient.fullName)
                        .font(.headline)
                    
                    HStack {
                        Text("MRN: \(patient.medicalRecordNumber)")
                        Text("•")
                        Text("Room: \(patient.roomNumber ?? "N/A")")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .buttonStyle(.borderless)
    }
} 