import SwiftUI

struct SettingsView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        List {
            Section("Account") {
                Button("Sign Out", role: .destructive) {
                    authManager.signOut()
                }
            }
        }
        .navigationTitle("Settings")
    }
} 