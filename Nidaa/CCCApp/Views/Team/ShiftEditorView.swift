import SwiftUI
import SwiftData

struct ShiftEditorView: View {
    let date: Date
    let teamMembers: [User]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedMembers: Set<UUID> = []
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(8 * 3600) // 8 hours later
    @State private var shiftType: ShiftType = .day
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Shift Details") {
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    
                    Picker("Shift Type", selection: $shiftType) {
                        ForEach(ShiftType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                                .tag(type)
                        }
                    }
                }
                
                Section("Team Members") {
                    ForEach(teamMembers) { member in
                        HStack {
                            UserAvatarView(user: member)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text(member.fullName)
                                    .font(.headline)
                                Text(member.role.rawValue.capitalized)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedMembers.contains(member.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleMember(member)
                        }
                    }
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Edit Shift")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveShift()
                    }
                    .disabled(selectedMembers.isEmpty)
                }
            }
        }
    }
    
    private func toggleMember(_ member: User) {
        if selectedMembers.contains(member.id) {
            selectedMembers.remove(member.id)
        } else {
            selectedMembers.insert(member.id)
        }
    }
    
    private func saveShift() {
        // Create a schedule for each selected team member
        for userId in selectedMembers {
            let schedule = Schedule(
                userId: userId,
                date: date,
                type: convertShiftType(shiftType),
                notes: notes.isEmpty ? nil : notes
            )
            modelContext.insert(schedule)
        }
        
        try? modelContext.save()
        dismiss()
    }
    
    private func convertShiftType(_ type: ShiftType) -> ScheduleType {
        switch type {
        case .day:
            return .day
        case .evening:
            return .evening
        case .night:
            return .night
        case .onCall:
            return .onCall
        }
    }
} 