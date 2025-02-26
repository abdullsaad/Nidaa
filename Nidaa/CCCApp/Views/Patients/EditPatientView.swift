import SwiftUI
import SwiftData

struct EditPatientView: View {
    @Environment(\.dismiss) private var dismiss
    let patient: Patient
    
    @State private var status: PatientStatus
    @State private var roomNumber: String
    @State private var selectedWard: String?
    @State private var selectedBed: String?
    
    init(patient: Patient) {
        self.patient = patient
        _status = State(initialValue: patient.status)
        _roomNumber = State(initialValue: patient.roomNumber ?? "")
        _selectedWard = State(initialValue: patient.wardInfo.wardNumber)
        _selectedBed = State(initialValue: patient.wardInfo.bedNumber)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Patient Status") {
                    Picker("Status", selection: $status) {
                        ForEach([PatientStatus.stable, .serious, .critical], id: \.self) { status in
                            Text(status.rawValue.capitalized)
                                .tag(status)
                        }
                    }
                }
                
                Section("Ward Assignment") {
                    Picker("Ward", selection: $selectedWard) {
                        ForEach(["3A", "ICU-1", "4A", "4B"], id: \.self) { ward in
                            Text(ward).tag(ward)
                        }
                    }
                    
                    if let ward = selectedWard {
                        Picker("Bed", selection: $selectedBed) {
                            ForEach(1...5, id: \.self) { number in
                                Text("\(ward)-\(number)").tag("\(ward)-\(number)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Patient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() }
                }
            }
        }
    }
    
    private func saveChanges() {
        patient.status = status
        patient.roomNumber = selectedBed
        patient.wardInfo = Patient.WardInfo(
            floorNumber: selectedWard?.first?.wholeNumberValue ?? 3,
            wardNumber: selectedWard ?? "",
            bedNumber: selectedBed ?? ""
        )
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Patient.self, configurations: config)
    let patient = Patient(
        firstName: "Naif",
        lastName: "Saad",
        dateOfBirth: Date(),
        medicalRecordNumber: "MRN-123",
        wardInfo: Patient.WardInfo(
            floorNumber: 3,
            wardNumber: "3A",
            bedNumber: "301"
        ),
        roomNumber: "301",
        assignedTeam: [UUID()],
        status: .stable
    )
    
    return NavigationStack {
        EditPatientView(patient: patient)
            .modelContainer(container)
    }
} 
