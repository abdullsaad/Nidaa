import SwiftUI

struct PatientMedicationsTab: View {
    let patient: Patient
    @State private var showingAddSheet = false
    
    var body: some View {
        List {
            if patient.medications.isEmpty {
                ContentUnavailableView(
                    "No Medications",
                    systemImage: "pills",
                    description: Text("This patient has no prescribed medications")
                )
            } else {
                ForEach(patient.medications) { medication in
                    MedicationRowView(medication: medication)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Medications")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddSheet.toggle() }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddMedicationView(patient: patient)
        }
    }
}

struct MedicationRowView: View {
    let medication: Medication
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(medication.name)
                    .font(.headline)
                
                Spacer()
                
                Text(medication.dosage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(medication.frequency)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let notes = medication.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label(medication.startDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                
                if let endDate = medication.endDate {
                    Text("to")
                    Text(endDate.formatted(date: .abbreviated, time: .omitted))
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
} 