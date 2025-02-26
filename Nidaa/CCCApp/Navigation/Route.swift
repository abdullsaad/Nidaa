import Foundation

enum Route: Hashable {
    case chat(User)
    case call(User)
    case schedule(User)
    case patient(Patient)
} 