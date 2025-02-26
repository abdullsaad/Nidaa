import SwiftUI
import SwiftData

struct TeamView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \User.lastName) private var users: [User]
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var selectedRole: UserRole?
    @State private var searchText = ""
    @State private var showScheduleSheet = false
    
    private var usersByRole: [UserRole: [User]] {
        Dictionary(grouping: filteredUsers) { $0.role }
    }
    
    private var filteredUsers: [User] {
        users.filter { user in
            // Filter conditions
            let matchesRole = selectedRole == nil || user.role == selectedRole
            let matchesSearch = searchText.isEmpty || 
                user.fullName.localizedCaseInsensitiveContains(searchText)
            let isNotCurrentUser = user.id != authManager.currentUserId
            
            return isNotCurrentUser && matchesRole && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                RoleFilterView(selectedRole: $selectedRole)
                
                if filteredUsers.isEmpty {
                    ContentUnavailableView(
                        "No Team Members",
                        systemImage: "person.2.slash",
                        description: Text("No team members found matching your criteria")
                    )
                } else {
                    List {
                        ForEach(UserRole.allCases, id: \.self) { role in
                            if let users = usersByRole[role], !users.isEmpty {
                                Section(role.rawValue.capitalized) {
                                    ForEach(users) { user in
                                        NavigationLink(value: user) {
                                            TeamMemberRow(user: user)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationDestination(for: User.self) { user in
                TeamMemberDetailView(user: user)
            }
            .navigationTitle("Team")
            .searchable(text: $searchText, prompt: "Search team members")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showScheduleSheet.toggle() }) {
                        Label("Schedule", systemImage: "calendar")
                    }
                }
            }
            .sheet(isPresented: $showScheduleSheet) {
                ScheduleView()
            }
        }
    }
} 