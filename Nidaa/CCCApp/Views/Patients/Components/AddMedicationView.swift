import SwiftUI
import SwiftData

struct AddMedicationView: View {
    let patient: Patient
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var dosage = ""
    @State private var frequency = ""
    @State private var startDate = Date()
    @State private var endDate: Date?
    @State private var notes = ""
    @State private var hasEndDate = false
    
    // Common frequencies for quick selection
    let commonFrequencies = [
        "Once daily",
        "Twice daily",
        "Three times daily",
        "Every 4 hours",
        "Every 6 hours",
        "Every 8 hours",
        "Every 12 hours",
        "As needed"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Medication Details") {
                    TextField("Name", text: $name)
                    TextField("Dosage", text: $dosage)
                    
                    Picker("Frequency", selection: $frequency) {
                        Text("Custom").tag("")
                        ForEach(commonFrequencies, id: \.self) { freq in
                            Text(freq).tag(freq)
                        }
                    }
                    
                    if frequency.isEmpty {
                        TextField("Custom Frequency", text: $frequency)
                    }
                }
                
                Section("Schedule") {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    
                    Toggle("Has End Date", isOn: $hasEndDate)
                    
                    if hasEndDate {
                        DatePicker(
                            "End Date",
                            selection: Binding(
                                get: { endDate ?? startDate },
                                set: { endDate = $0 }
                            ),
                            in: startDate...,
                            displayedComponents: .date
                        )
                    }
                }
                
                Section("Additional Information") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addMedication()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !name.isEmpty && !dosage.isEmpty && !frequency.isEmpty
    }
    
    private func addMedication() {
        let medication = Medication(
            name: name,
            dosage: dosage,
            frequency: frequency,
            startDate: startDate,
            endDate: hasEndDate ? endDate : nil,
            notes: notes.isEmpty ? nil : notes
        )
        
        patient.medications.append(medication)
        dismiss()
    }
} 