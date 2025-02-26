import Foundation
import SwiftData

@MainActor
final class DemoDataManager {
    static let shared = DemoDataManager()
    
    // Main setup function with improved error handling and logging
    func setupDemoData(in context: ModelContext) async throws {
        print("Starting demo data setup...")
        
        // Check if we already have users
        let userCount = try context.fetchCount(FetchDescriptor<User>())
        let patientCount = try context.fetchCount(FetchDescriptor<Patient>())
        
        print("Current data: \(userCount) users, \(patientCount) patients")
        
        if userCount == 0 {
            print("No users found. Creating demo data...")
            
            // Create a simple doctor directly
            let doctor = User(
                id: UUID(),  // Explicitly set ID
                firstName: "Abdullah",
                lastName: "Al-Ghamdi",
                email: "abdullah.ghamdi@hospital.com",
                phoneNumber: "0501234567",
                department: "Cardiology",
                specialty: "Interventional Cardiology",
                role: .doctor,
                status: .active,
                employeeId: "D1001"
            )
            
            // Insert the doctor
            context.insert(doctor)
            
            // Try to save immediately after inserting the doctor
            do {
                try context.save()
                print("Successfully saved doctor")
            } catch {
                print("Error saving doctor: \(error.localizedDescription)")
                throw error
            }
            
            // Create a simple patient directly
            let doctorId = doctor.id
            let patient = Patient(
                id: UUID(),  // Explicitly set ID
                firstName: "Fatima",
                lastName: "Al-Ghamdi",
                dateOfBirth: Calendar.current.date(byAdding: .year, value: -52, to: Date()) ?? Date(),
                medicalRecordNumber: "MRN-123459",
                wardInfo: Patient.WardInfo(
                    floorNumber: 3,
                    wardNumber: "3A",
                    bedNumber: "302-A"
                ),
                roomNumber: "302-A",
                assignedTeam: [doctorId],
                status: .stable
            )
            
            // Add additional properties
            patient.chiefComplaint = "Fever and productive cough for 3 days"
            patient.activeProblems = ["Community-acquired pneumonia", "Asthma", "Hypertension"]
            
            // Insert the patient
            context.insert(patient)
            
            // Save changes
            do {
                try context.save()
                print("Successfully saved patient")
                
                // Set current user
                UserManager.shared.setCurrentUser(doctor)
                print("Set current user to: \(doctor.fullName)")
            } catch {
                print("Error saving patient: \(error.localizedDescription)")
                throw error
            }
            
            // Verify data was created
            let verifyUserCount = try context.fetchCount(FetchDescriptor<User>())
            let verifyPatientCount = try context.fetchCount(FetchDescriptor<Patient>())
            print("After creation: \(verifyUserCount) users, \(verifyPatientCount) patients")
            
            // Force refresh the UI
            NotificationCenter.default.post(name: NSNotification.Name("RefreshData"), object: nil)
        } else {
            print("Found existing users, skipping demo data setup")
            
            // Just set a current user (but don't authenticate)
            let descriptor = FetchDescriptor<User>()
            let existingUsers = try context.fetch(descriptor)
            
            if let doctor = existingUsers.first(where: { $0.role == .doctor }) {
                UserManager.shared.setCurrentUser(doctor)
                print("Set current user to: \(doctor.fullName)")
            }
        }
    }
    
    // Reset function - improved with better error handling
    func resetDemoData(in context: ModelContext) async throws {
        print("Resetting demo data...")
        
        // Delete all existing data
        try deleteAllEntities(in: context)
        
        // Setup fresh data
        try await setupDemoData(in: context)
    }
    
    // Delete all entities with improved error handling
    private func deleteAllEntities(in context: ModelContext) throws {
        print("Deleting all existing data...")
        
        // Delete in a specific order to avoid relationship issues
        try deleteEntities(of: PersonalizedPatientStatus.self, in: context)
        try deleteEntities(of: Message.self, in: context)
        try deleteEntities(of: Schedule.self, in: context)
        try deleteEntities(of: Patient.self, in: context)
        try deleteEntities(of: User.self, in: context)
        
        print("All data deleted")
    }
    
    // Helper to delete entities of a specific type
    private func deleteEntities<T: PersistentModel>(of type: T.Type, in context: ModelContext) throws {
        let descriptor = FetchDescriptor<T>()
        let entities = try context.fetch(descriptor)
        
        print("Deleting \(entities.count) \(String(describing: type)) entities")
        
        for entity in entities {
            context.delete(entity)
        }
        
        try context.save()
        print("Successfully deleted \(entities.count) \(String(describing: type)) entities")
    }
    
    // Create sample data directly in the view
    func createSampleDataDirectly(in context: ModelContext) {
        print("Creating sample data directly...")
        
        // Create a doctor
        let doctorId = UUID()
        let doctor = User(
            id: doctorId,
            firstName: "Abdullah",
            lastName: "Al-Ghamdi",
            email: "abdullah.ghamdi@hospital.com",
            phoneNumber: "0501234567",
            department: "Cardiology",
            specialty: "Interventional Cardiology",
            role: .doctor,
            status: .active,
            employeeId: "D1001"
        )
        
        // Create a patient
        let patientId = UUID()
        let patient = Patient(
            id: patientId,
            firstName: "Fatima",
            lastName: "Al-Ghamdi",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -52, to: Date()) ?? Date(),
            medicalRecordNumber: "MRN-123459",
            wardInfo: Patient.WardInfo(
                floorNumber: 3,
                wardNumber: "3A",
                bedNumber: "302-A"
            ),
            roomNumber: "302-A",
            assignedTeam: [doctorId],
            status: .stable
        )
        
        // Add chief complaint and active problems
        patient.chiefComplaint = "Fever and productive cough for 3 days"
        patient.activeProblems = ["Community-acquired pneumonia", "Asthma", "Hypertension"]
        
        // Insert into context
        context.insert(doctor)
        
        // Save after doctor
        do {
            try context.save()
            print("Doctor saved successfully")
        } catch {
            print("Error saving doctor: \(error.localizedDescription)")
            return
        }
        
        context.insert(patient)
        
        // Save after patient
        do {
            try context.save()
            print("Patient saved successfully")
            
            // Set current user
            UserManager.shared.setCurrentUser(doctor)
        } catch {
            print("Error saving patient: \(error.localizedDescription)")
        }
        
        // Force refresh the UI
        NotificationCenter.default.post(name: NSNotification.Name("RefreshData"), object: nil)
    }
} 