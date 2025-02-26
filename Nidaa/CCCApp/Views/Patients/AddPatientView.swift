import SwiftUI
import SwiftData

struct AddPatientView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var userManager = UserManager.shared
    
    // Patient information
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var dateOfBirth = Date()
    @State private var medicalRecordNumber = ""
    @State private var roomNumber = ""
    @State private var floorNumber = 1
    @State private var wardNumber = ""
    @State private var bedNumber = ""
    @State private var status: PatientStatus = .stable
    
    // Form validation
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Patient Information") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    TextField("Medical Record Number", text: $medicalRecordNumber)
                }
                
                Section("Room Information") {
                    TextField("Room Number", text: $roomNumber)
                    Stepper("Floor: \(floorNumber)", value: $floorNumber, in: 1...20)
                    TextField("Ward", text: $wardNumber)
                    TextField("Bed", text: $bedNumber)
                }
                
                Section("Status") {
                    Picker("Status", selection: $status) {
                        ForEach(PatientStatus.allCases, id: \.self) { status in
                            Text(status.rawValue.capitalized)
                                .tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Add Patient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        savePatient()
                    }
                }
            }
            .alert("Missing Information", isPresented: $showingValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }
        }
    }
    
    private func savePatient() {
        // Validate required fields
        if firstName.isEmpty || lastName.isEmpty || medicalRecordNumber.isEmpty {
            validationMessage = "Please fill in all required fields."
            showingValidationAlert = true
            return
        }
        
        // Get current user ID
        guard let currentUser = userManager.getCurrentUser() else {
            validationMessage = "Error: No current user set"
            showingValidationAlert = true
            return
        }
        
        let currentUserId = currentUser.id
        
        // Create ward info
        let wardInfo = Patient.WardInfo(
            floorNumber: floorNumber,
            wardNumber: wardNumber,
            bedNumber: bedNumber
        )
        
        // Create new patient
        let patient = Patient(
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            medicalRecordNumber: medicalRecordNumber,
            wardInfo: wardInfo,
            roomNumber: roomNumber,
            assignedTeam: [currentUserId],
            status: status
        )
        
        // Save to database
        modelContext.insert(patient)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            validationMessage = "Error saving patient: \(error.localizedDescription)"
            showingValidationAlert = true
        }
    }
}

#Preview {
    AddPatientView()
        .modelContainer(for: Patient.self, inMemory: true)
} 
