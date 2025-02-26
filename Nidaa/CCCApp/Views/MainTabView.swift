import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .patients
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PatientsView()
                .tabItem {
                    Label("Patients", systemImage: "heart.text.square")
                }
                .tag(Tab.patients)
            
            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
                .tag(Tab.messages)
            
            TeamView()
                .tabItem {
                    Label("Team", systemImage: "person.2")
                }
                .tag(Tab.team)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
    }
}

enum Tab {
    case patients
    case messages
    case team
    case settings
} 