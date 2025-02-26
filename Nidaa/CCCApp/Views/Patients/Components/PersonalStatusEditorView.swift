import SwiftUI
import SwiftData

struct PersonalStatusEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var authManager = AuthenticationManager.shared
    
    let patient: Patient
    let currentStatus: PersonalizedPatientStatus?
    
    @State private var selectedStatus: PatientStatus
    @State private var notes: String = ""
    
    init(patient: Patient, currentStatus: PersonalizedPatientStatus?) {
        self.patient = patient
        self.currentStatus = currentStatus
        _selectedStatus = State(initialValue: currentStatus?.status ?? .stable)
        _notes = State(initialValue: currentStatus?.notes ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Status") {
                    StatusPickerView(selectedStatus: $selectedStatus)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Update Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveStatus() }
                }
            }
        }
    }
    
    private func saveStatus() {
        if let existing = currentStatus {
            existing.status = selectedStatus
            existing.notes = notes.isEmpty ? nil : notes
            existing.lastUpdated = Date()
        } else {
            let newStatus = PersonalizedPatientStatus(
                patientId: patient.id,
                userId: authManager.currentUserId,
                status: selectedStatus,
                notes: notes.isEmpty ? nil : notes
            )
            modelContext.insert(newStatus)
        }
        
        patient.status = selectedStatus
        
        try? modelContext.save()
        dismiss()
    }
}

struct StatusPickerView: View {
    @Binding var selectedStatus: PatientStatus
    
    var body: some View {
        Picker("Status", selection: $selectedStatus) {
            ForEach(PatientStatus.allCases, id: \.self) { status in
                StatusPickerRow(status: status)
                    .tag(status)
            }
        }
    }
}

struct StatusPickerRow: View {
    let status: PatientStatus
    
    var body: some View {
        Label {
            Text(status.rawValue.capitalized)
        } icon: {
            Image(systemName: status.statusIcon)
                .foregroundColor(status.statusColor)
        }
    }
} 