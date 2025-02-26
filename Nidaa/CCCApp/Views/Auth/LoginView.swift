import SwiftUI
import SwiftData  // Add this import for FetchDescriptor

struct LoginView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showingError = false
    @State private var isLoading = false
    @State private var errorMessage = "Please check your credentials and try again."
    
    var body: some View {
        // Wrap everything in a ZStack to ensure it's responsive
        ZStack {
            // Background color
            Color(.systemBackground).ignoresSafeArea()
            
            // Main content
            ScrollView {
                VStack(spacing: 24) {
                    // Logo and welcome
                    VStack(spacing: 16) {
                        Image(systemName: "stethoscope")
                            .font(.system(size: 60))
                            .foregroundColor(.accentColor)
                        
                        Text("Welcome to Nidaa")
                            .font(.title)
                            .bold()
                        
                        Text("Your medical team communication platform")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // Login Form - explicitly set frame and add padding
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .frame(height: 44)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.password)
                            .frame(height: 44)
                    }
                    .padding(.vertical)
                    
                    // Login Button - make it larger and more tappable
                    Button {
                        login()
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .tint(.white)
                            } else {
                                Text("Sign In")
                                    .font(.headline)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle()) // Use plain style to avoid interference
                    .disabled(isLoading)
                    
                    // Demo login helper - make it more prominent
                    if !isLoading {
                        Button {
                            email = "abdullah.ghamdi@hospital.com"
                            password = "password123"
                            // Auto-login with demo account
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                login()
                            }
                        } label: {
                            Text("Use Demo Account")
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.top, 16)
                    }
                    
                    // Direct login button that bypasses the normal flow
                    Button("Emergency Login") {
                        directLogin()
                    }
                    .padding()
                    .font(.footnote)
                    .foregroundColor(.red)
                    .disabled(isLoading)
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
            .alert("Login Failed", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
        // Add a tap gesture to dismiss keyboard
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private func login() {
        // Dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        isLoading = true
        
        // For demo purposes, accept any non-empty input with a slight delay to simulate network
        if !email.isEmpty && !password.isEmpty {
            // Add a slight delay to simulate network request
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Task {
                    do {
                        // Print debug info
                        print("Attempting to login with email: \(self.email)")
                        
                        try await authManager.signIn(email: self.email, password: self.password)
                        print("Login successful")
                        isLoading = false
                    } catch {
                        print("Login failed: \(error)")
                        errorMessage = error.localizedDescription
                        showingError = true
                        isLoading = false
                    }
                }
            }
        } else {
            errorMessage = "Email and password cannot be empty"
            showingError = true
            isLoading = false
        }
    }
    
    // Direct login that bypasses the normal authentication flow
    private func directLogin() {
        print("Attempting emergency direct login")
        
        // Set authenticated state directly
        authManager.isAuthenticated = true
        
        // Try to find a doctor to set as current user
        if let modelContext = ModelManager.shared.modelContainer?.mainContext {
            do {
                // Create demo staff members
                let demoStaff = [
                    User(
                        firstName: "Abdullah",
                        lastName: "Al-Ghamdi",
                        email: "abdullah.ghamdi@hospital.com",
                        phoneNumber: "0501234567",
                        department: "Cardiology",
                        specialty: "Interventional Cardiology",
                        role: .doctor,
                        status: .active
                    ),
                    User(
                        firstName: "Noura",
                        lastName: "Al-Qahtani",
                        email: "noura.qahtani@hospital.com",
                        phoneNumber: "0505678901",
                        department: "ICU",
                        specialty: "Critical Care",
                        role: .nurse,
                        status: .active
                    ),
                    User(
                        firstName: "Reem",
                        lastName: "Al-Malki",
                        email: "reem.malki@hospital.com",
                        phoneNumber: "0509012345",
                        department: "Radiology",
                        specialty: "Diagnostic Imaging",
                        role: .specialist,
                        status: .active
                    ),
                    User(
                        firstName: "Ahmed",
                        lastName: "Al-Dossari",
                        email: "ahmed.dossari@hospital.com",
                        phoneNumber: "0506789012",
                        department: "Emergency",
                        specialty: "Emergency Care",
                        role: .nurse,
                        status: .active
                    )
                ]
                
                // Create and insert demo staff
                demoStaff.forEach { modelContext.insert($0) }
                
                // Create demo patients
                let demoPatients = [
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
                
                // Create and insert demo patients
                demoPatients.forEach { modelContext.insert($0) }
                
                // Save all changes
                try modelContext.save()
                
                // Set current user as the first doctor
                if let doctor = demoStaff.first(where: { $0.role == .doctor }) {
                    authManager.setCurrentUserDirectly(doctor)
                    print("Emergency login successful with user: \(doctor.fullName)")
                }
                
                // Notify views to refresh
                NotificationCenter.default.post(name: NSNotification.Name("RefreshData"), object: nil)
                
            } catch {
                print("Error in emergency login: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    LoginView()
} 