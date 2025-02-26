import Foundation
import SwiftData

@MainActor
final class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published private(set) var currentUserId: UUID = UUID()
    private var modelContext: ModelContext?
    
    private init() {}
    
    func initialize(with context: ModelContext) {
        modelContext = context
        print("AuthenticationManager initialized with context")
        
        // Reset authentication state on app start
        isAuthenticated = false
    }
    
    func signIn(email: String, password: String) async throws {
        // For demo purposes, find a user with matching email
        guard let modelContext = modelContext else {
            print("Error: Model context not initialized")
            throw AuthError.noContext
        }
        
        // Print debug info
        print("Attempting to sign in with email: \(email)")
        
        // Since this is a demo app, we'll use a simple equality check
        // In a real app, you would use a more secure approach
        let descriptor = FetchDescriptor<User>()
        let allUsers = try modelContext.fetch(descriptor)
        
        print("Found \(allUsers.count) users in database")
        
        // Debug: print all users
        for user in allUsers {
            print("User: \(user.fullName), Email: \(user.email)")
        }
        
        // Find user with matching email
        if let user = allUsers.first(where: { $0.email.lowercased() == email.lowercased() }) {
            print("User found: \(user.fullName)")
            currentUserId = user.id
            isAuthenticated = true
            
            // Also update UserManager
            UserManager.shared.setCurrentUser(user)
            return
        }
        
        // For demo, if no matching user, just use the first doctor
        if let doctor = allUsers.first(where: { $0.role == .doctor }) {
            print("No matching user found, using first doctor: \(doctor.fullName)")
            currentUserId = doctor.id
            isAuthenticated = true
            
            // Also update UserManager
            UserManager.shared.setCurrentUser(doctor)
            return
        }
        
        print("No users found in database")
        throw AuthError.invalidCredentials
    }
    
    func signOut() {
        isAuthenticated = false
        print("User signed out")
    }
    
    func setCurrentUser(_ user: User) {
        currentUserId = user.id
        // Don't automatically authenticate when setting current user
        print("Current user set to: \(user.fullName)")
    }
    
    // For demo purposes, provide a simple way to bypass login
    func demoLogin() {
        guard let modelContext = modelContext else { 
            print("Error: Model context not initialized")
            return
        }
        
        do {
            let descriptor = FetchDescriptor<User>()
            let users = try modelContext.fetch(descriptor)
            
            print("Found \(users.count) users for demo login")
            
            if let doctor = users.first(where: { $0.role == .doctor }) {
                currentUserId = doctor.id
                isAuthenticated = true
                UserManager.shared.setCurrentUser(doctor)
                print("Demo login as: \(doctor.fullName)")
            } else {
                print("No doctor found for demo login")
            }
        } catch {
            print("Demo login failed: \(error.localizedDescription)")
        }
    }
    
    // Direct authentication for emergency situations
    func setCurrentUserDirectly(_ user: User) {
        currentUserId = user.id
        isAuthenticated = true
        UserManager.shared.setCurrentUser(user)
        print("Direct authentication successful for: \(user.fullName)")
    }
}

enum AuthError: Error, CustomStringConvertible {
    case invalidCredentials
    case noContext
    
    var description: String {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .noContext:
            return "Database context not available"
        }
    }
} 