import Foundation
import SwiftData

@MainActor
final class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published private(set) var currentUser: User?
    private var modelContext: ModelContext?
    
    private init() {}
    
    func initialize(with context: ModelContext) {
        self.modelContext = context
        print("UserManager initialized with context")
    }
    
    func setCurrentUser(_ user: User) {
        currentUser = user
        print("Current user set to: \(user.fullName)")
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func fetchUserById(id: UUID) -> User? {
        guard let modelContext = modelContext else { return nil }
        
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.id == id })
        
        do {
            let users = try modelContext.fetch(descriptor)
            return users.first
        } catch {
            print("Error fetching user by ID: \(error.localizedDescription)")
            return nil
        }
    }
} 