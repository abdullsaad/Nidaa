import SwiftUI

struct TeamActionsView: View {
    let patient: Patient
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        TeamChatView(patient: patient)
                    } label: {
                        Label("Team Chat", systemImage: "bubble.left.and.bubble.right.fill")
                    }
                    
                    NavigationLink {
                        ManageTeamView(patient: patient)
                    } label: {
                        Label("Manage Team", systemImage: "person.2.badge.gearshape")
                    }
                    
                    NavigationLink {
                        TeamScheduleView()
                    } label: {
                        Label("Schedule", systemImage: "calendar")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        // Handle emergency action
                    } label: {
                        Label("Emergency Alert", systemImage: "exclamationmark.triangle.fill")
                    }
                }
            }
            .navigationTitle("Team Actions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 