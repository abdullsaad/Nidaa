import SwiftUI
import SwiftData

struct AddScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var users: [User]
    
    @State private var selectedUser: User?
    @State private var selectedDate = Date()
    @State private var scheduleType: ScheduleType = .day
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Team Member") {
                    Picker("Select Member", selection: $selectedUser) {
                        Text("Select a team member").tag(nil as User?)
                        ForEach(users) { user in
                            Text(user.fullName).tag(user as User?)
                        }
                    }
                }
                
                Section("Schedule Details") {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: [.date])
                    Picker("Type", selection: $scheduleType) {
                        ForEach(ScheduleType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveSchedule() }
                        .disabled(selectedUser == nil)
                }
            }
        }
    }
    
    private func saveSchedule() {
        guard let user = selectedUser else { return }
        
        let schedule = Schedule(
            userId: user.id,
            date: selectedDate,
            type: scheduleType,
            notes: notes.isEmpty ? nil : notes
        )
        
        modelContext.insert(schedule)
        dismiss()
    }
}

#Preview {
    AddScheduleView()
        .modelContainer(for: Schedule.self, inMemory: true)
} 