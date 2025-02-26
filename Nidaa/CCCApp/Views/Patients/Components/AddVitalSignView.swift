import SwiftUI
import SwiftData

struct AddVitalSignView: View {
    let patient: Patient
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedType: VitalSignType = .bloodPressure
    @State private var value: String = ""
    @State private var timestamp = Date()
    
    private var unit: String {
        switch selectedType {
        case .bloodPressure:
            return "mmHg"
        case .heartRate:
            return "bpm"
        case .temperature:
            return "°C"
        case .oxygenSaturation:
            return "%"
        case .respiratoryRate:
            return "breaths/min"
        }
    }
    
    private var isValid: Bool {
        guard let doubleValue = Double(value) else { return false }
        
        switch selectedType {
        case .bloodPressure:
            return doubleValue >= 70 && doubleValue <= 200
        case .heartRate:
            return doubleValue >= 40 && doubleValue <= 200
        case .temperature:
            return doubleValue >= 35 && doubleValue <= 42
        case .oxygenSaturation:
            return doubleValue >= 70 && doubleValue <= 100
        case .respiratoryRate:
            return doubleValue >= 8 && doubleValue <= 40
        }
    }
    
    private var lastReading: VitalSign? {
        patient.vitalSigns
            .filter { $0.type == selectedType }
            .sorted { $0.timestamp > $1.timestamp }
            .first
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Vital Sign") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(VitalSignType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    HStack {
                        TextField("Value", text: $value)
                            .keyboardType(.decimalPad)
                        
                        Text(unit)
                            .foregroundColor(.secondary)
                    }
                    
                    DatePicker("Time", selection: $timestamp)
                }
                
                if let last = lastReading {
                    Section("Last Reading") {
                        LabeledContent("Value", value: "\(Int(last.value)) \(last.unit)")
                        LabeledContent("Time", value: last.timestamp.formatted())
                    }
                }
            }
            .navigationTitle("Add Vital Sign")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addVitalSign()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private func addVitalSign() {
        guard let value = Double(value) else { return }
        
        let vitalSign = VitalSign(
            timestamp: timestamp,
            type: selectedType,
            value: value,
            unit: unit
        )
        
        patient.vitalSigns.append(vitalSign)
        dismiss()
    }
} 