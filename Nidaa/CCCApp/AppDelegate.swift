import UIKit
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Application launched")
        // Create demo data immediately
        createInitialDemoData()
        return true
    }
    
    private func createInitialDemoData() {
        guard let modelContainer = ModelManager.shared.modelContainer else {
            print("❌ Model container not available")
            return
        }
        
        let context = modelContainer.mainContext
        
        // Create demo patients directly
        let patients = [
            Patient(
                firstName: "Ahmed",
                lastName: "Al-Rashid",
                dateOfBirth: Date(),
                medicalRecordNumber: "MRN-001",
                wardInfo: Patient.WardInfo(floorNumber: 1, wardNumber: "ICU", bedNumber: "101"),
                roomNumber: "101",
                assignedTeam: [],
                status: .critical
            ),
            Patient(
                firstName: "Fatima",
                lastName: "Al-Ghamdi",
                dateOfBirth: Date(),
                medicalRecordNumber: "MRN-002",
                wardInfo: Patient.WardInfo(floorNumber: 3, wardNumber: "3A", bedNumber: "301"),
                roomNumber: "301",
                assignedTeam: [],
                status: .stable
            ),
            Patient(
                firstName: "Mohammed",
                lastName: "Al-Shehri",
                dateOfBirth: Date(),
                medicalRecordNumber: "MRN-003",
                wardInfo: Patient.WardInfo(floorNumber: 3, wardNumber: "3B", bedNumber: "310"),
                roomNumber: "310",
                assignedTeam: [],
                status: .stable
            )
        ]
        
        // Create a doctor
        let doctor = User(
            firstName: "Abdullah",
            lastName: "Al-Ghamdi",
            email: "abdullah.ghamdi@hospital.com",
            role: .doctor
        )
        
        // Insert all data
        context.insert(doctor)
        patients.forEach { context.insert($0) }
        
        // Save immediately
        try? context.save()
        
        // Set current user
        UserManager.shared.setCurrentUser(doctor)
        UserManager.shared.initialize(with: context)
        
        // Notify of data creation
        NotificationCenter.default.post(name: NSNotification.Name("RefreshData"), object: nil)
    }
} 