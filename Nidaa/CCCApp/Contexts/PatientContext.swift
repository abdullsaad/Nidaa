import SwiftUI
import SwiftData

// Create a patient context to manage patient data across the app
class PatientViewModel: ObservableObject {
    static let shared = PatientViewModel()
    
    @Published var patients: [Patient] = []
    @Published var filteredPatients: [Patient] = []
    @Published var selectedFilter: PatientFilter = .all
    @Published var searchText: String = ""
    
    private var modelContext: ModelContext?
    
    func initialize(with context: ModelContext) {
        self.modelContext = context
        fetchPatients()
    }
    
    func fetchPatients() {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<Patient>(sortBy: [SortDescriptor(\.lastName)])
            patients = try modelContext.fetch(descriptor)
            applyFilters()
        } catch {
            print("Error fetching patients: \(error.localizedDescription)")
        }
    }
    
    func applyFilters() {
        filteredPatients = patients.filter { patient in
            let matchesSearch = searchText.isEmpty || 
                patient.fullName.localizedCaseInsensitiveContains(searchText)
            
            let matchesFilter: Bool
            switch selectedFilter {
            case .all:
                matchesFilter = true
            case .critical:
                matchesFilter = patient.status == .critical
            case .stable:
                matchesFilter = patient.status == .stable
            }
            
            return matchesSearch && matchesFilter
        }
    }
    
    func updatePatientInList(_ updatedPatient: Patient) {
        // Find and update the patient in the list
        if let index = patients.firstIndex(where: { $0.id == updatedPatient.id }) {
            patients[index] = updatedPatient
        }
        
        // Also update in filtered list if present
        if let filteredIndex = filteredPatients.firstIndex(where: { $0.id == updatedPatient.id }) {
            filteredPatients[filteredIndex] = updatedPatient
        }
        
        // Save changes to the database
        try? modelContext?.save()
    }
    
    func addPatient(_ patient: Patient) {
        guard let modelContext = modelContext else { return }
        
        modelContext.insert(patient)
        patients.append(patient)
        applyFilters()
        
        try? modelContext.save()
    }
    
    func deletePatient(_ patient: Patient) {
        guard let modelContext = modelContext else { return }
        
        modelContext.delete(patient)
        
        if let index = patients.firstIndex(where: { $0.id == patient.id }) {
            patients.remove(at: index)
        }
        
        applyFilters()
        
        try? modelContext.save()
    }
    
    func refreshPatients() {
        fetchPatients()
        print("Refreshed patient list: \(patients.count) patients found")
    }
}

// Create a SwiftUI environment key for the patient view model
struct PatientViewModelKey: EnvironmentKey {
    static let defaultValue = PatientViewModel.shared
}

extension EnvironmentValues {
    var patientViewModel: PatientViewModel {
        get { self[PatientViewModelKey.self] }
        set { self[PatientViewModelKey.self] = newValue }
    }
} 