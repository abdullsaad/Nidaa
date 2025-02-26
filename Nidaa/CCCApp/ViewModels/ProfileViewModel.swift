import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isEditing = false
    
    init(user: User) {
        self.user = user
    }
    
    func updateStatus(_ status: UserStatus) {
        user.status = status
    }
    
    func updateProfile(
        firstName: String,
        lastName: String,
        email: String,
        phoneNumber: String,
        department: String
    ) {
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.phoneNumber = phoneNumber
        user.department = department
    }
} 