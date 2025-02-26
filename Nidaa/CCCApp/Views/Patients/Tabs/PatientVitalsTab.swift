import SwiftUI
import Charts

struct PatientVitalsTab: View {
    let patient: Patient
    @State private var selectedType: VitalSignType = .bloodPressure
    @State private var showingAddSheet = false
    
    var body: some View {
        List {
            Section {
                Picker("Type", selection: $selectedType) {
                    ForEach(VitalSignType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .listRowInsets(EdgeInsets())
                .padding()
            }
            
            if let latestReading = latestVitalSign {
                Section("Latest Reading") {
                    VitalSignRowView(vitalSign: latestReading)
                }
            }
            
            if !filteredVitalSigns.isEmpty {
                Section("History") {
                    Chart(filteredVitalSigns) { reading in
                        LineMark(
                            x: .value("Time", reading.timestamp),
                            y: .value("Value", reading.value)
                        )
                        .foregroundStyle(chartColor)
                        
                        PointMark(
                            x: .value("Time", reading.timestamp),
                            y: .value("Value", reading.value)
                        )
                        .foregroundStyle(chartColor)
                    }
                    .frame(height: 200)
                    .padding(.vertical)
                    
                    ForEach(filteredVitalSigns) { reading in
                        VitalSignRowView(vitalSign: reading)
                    }
                }
            } else {
                ContentUnavailableView(
                    "No Readings",
                    systemImage: "waveform.path.ecg",
                    description: Text("No vital signs have been recorded")
                )
            }
        }
        .navigationTitle("Vital Signs")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddSheet.toggle() }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddVitalSignView(patient: patient)
        }
    }
    
    private var filteredVitalSigns: [VitalSign] {
        patient.vitalSigns
            .filter { $0.type == selectedType }
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    private var latestVitalSign: VitalSign? {
        filteredVitalSigns.first
    }
    
    private var chartColor: Color {
        switch selectedType {
        case .bloodPressure:
            return .red
        case .heartRate:
            return .pink
        case .temperature:
            return .orange
        case .oxygenSaturation:
            return .blue
        case .respiratoryRate:
            return .green
        }
    }
}

struct VitalSignRowView: View {
    let vitalSign: VitalSign
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(vitalSign.value)) \(vitalSign.unit)")
                    .font(.headline)
                
                Text(vitalSign.timestamp.formatted())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(vitalSign.type.rawValue)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
} 