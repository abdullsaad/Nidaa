import SwiftUI
import SwiftData

struct TeamScheduleView: View {
    @Query private var users: [User]
    @Query private var schedules: [Schedule]
    @State private var selectedDate = Date()
    @State private var showingShiftEditor = false
    
    private var dailySchedules: [Schedule] {
        schedules.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Calendar
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                // Schedule List
                List {
                    ForEach(dailySchedules) { schedule in
                        if let user = users.first(where: { $0.id == schedule.userId }) {
                            ScheduleRow(schedule: schedule, user: user)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Team Schedule")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingShiftEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingShiftEditor) {
                ShiftEditorView(date: selectedDate, teamMembers: users)
            }
        }
    }
}

struct ScheduleRow: View {
    let schedule: Schedule
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            UserAvatarView(user: user)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.headline)
                
                Text(schedule.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Circle()
                .fill(typeColor)
                .frame(width: 8, height: 8)
        }
        .padding(.vertical, 8)
    }
    
    private var typeColor: Color {
        switch schedule.type {
        case .day:
            return .blue
        case .evening:
            return .orange
        case .night:
            return .purple
        case .onCall:
            return .green
        }
    }
} 