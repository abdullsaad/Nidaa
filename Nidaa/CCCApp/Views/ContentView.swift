import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var showingOnboarding = false
    @Environment(\.patientViewModel) private var patientViewModel
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
                    .onAppear {
                        // Refresh patient data when main view appears
                        patientViewModel.refreshPatients()
                    }
            } else {
                LoginView()
            }
        }
        .task {
            if !UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                showingOnboarding = true
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            }
        }
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            User.self,
            Message.self,
            Patient.self,
            PatientAlert.self,
            Schedule.self,
            Medication.self,
            VitalSign.self
        ], inMemory: true)
}
