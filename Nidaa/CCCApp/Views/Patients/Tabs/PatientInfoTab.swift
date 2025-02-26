import SwiftUI

struct PatientInfoTab: View {
    let patient: Patient
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Chief Complaint - more prominent
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "stethoscope")
                            .foregroundColor(.accentColor)
                        Text("Chief Complaint")
                            .font(.headline)
                    }
                    
                    if let chiefComplaint = patient.chiefComplaint {
                        Text(chiefComplaint)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    } else {
                        Text("No chief complaint recorded")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
                
                // Active Problems - better visual hierarchy
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "list.bullet.clipboard")
                            .foregroundColor(.accentColor)
                        Text("Active Problems")
                            .font(.headline)
                    }
                    
                    if !patient.activeProblems.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(patient.activeProblems, id: \.self) { problem in
                                HStack(alignment: .top, spacing: 12) {
                                    Circle()
                                        .fill(Color.accentColor)
                                        .frame(width: 6, height: 6)
                                        .padding(.top, 8)
                                    
                                    Text(problem)
                                        .padding(.vertical, 8)
                                }
                                
                                if problem != patient.activeProblems.last {
                                    Divider()
                                        .padding(.leading, 18)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    } else {
                        Text("No active problems recorded")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
                
                // Allergies - with warning icons
                if !patient.allergies.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                            Text("Allergies")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(patient.allergies, id: \.self) { allergy in
                                HStack(spacing: 12) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                    
                                    Text(allergy)
                                        .padding(.vertical, 8)
                                }
                                
                                if allergy != patient.allergies.last {
                                    Divider()
                                        .padding(.leading, 24)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                
                // Physical measurements
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "figure.arms.open")
                            .foregroundColor(.accentColor)
                        Text("Physical Measurements")
                            .font(.headline)
                    }
                    
                    VStack(spacing: 0) {
                        MeasurementRow(
                            label: "Height",
                            value: patient.height != nil ? "\(Int(patient.height!)) cm" : "Not recorded",
                            icon: "ruler"
                        )
                        
                        Divider()
                            .padding(.leading, 40)
                        
                        MeasurementRow(
                            label: "Weight",
                            value: patient.weight != nil ? "\(Int(patient.weight!)) kg" : "Not recorded",
                            icon: "scalemass"
                        )
                        
                        if patient.bmi != nil {
                            Divider()
                                .padding(.leading, 40)
                            
                            MeasurementRow(
                                label: "BMI",
                                value: String(format: "%.1f", patient.bmi!),
                                icon: "figure.arms.open"
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct MeasurementRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            
            Text(label)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.vertical, 8)
    }
}

