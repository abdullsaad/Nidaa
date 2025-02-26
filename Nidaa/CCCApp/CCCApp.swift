import SwiftUI
import SwiftData

@main
struct CCCApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var modelManager = ModelManager.shared
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var patientViewModel = PatientViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    User.self,
                    Message.self,
                    Schedule.self,
                    EmergencyAlert.self,
                    Attachment.self,
                    Patient.self,
                    Medication.self,
                    VitalSign.self,
                    PersonalizedPatientStatus.self
                ]) { result in
                    switch result {
                    case .success(let container):
                        print("Model container setup successful")
                        modelManager.setModelContainer(container)
                        modelManager.setModelContext(container.mainContext)
                        authManager.initialize(with: container.mainContext)
                        patientViewModel.initialize(with: container.mainContext)
                        
                        // No need to call DemoDataManager here, AppDelegate will handle it
                    case .failure(let error):
                        print("Failed to set up model container: \(error.localizedDescription)")
                    }
                }
                .environment(\.patientViewModel, patientViewModel)
                .preferredColorScheme(.light)
        }
    }
}

@MainActor
final class DataManager: ObservableObject {
    static let shared = DataManager()
} 
