import SwiftUI
import SwiftData

struct ScheduleView: View {
    @Query private var schedules: [Schedule]
    @StateObject private var authManager = AuthenticationManager.shared
    
    private var mySchedules: [Schedule] {
        schedules.filter { $0.userId == authManager.currentUserId }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(mySchedules) { schedule in
                    ScheduleRowView(schedule: schedule)
                }
            }
            .navigationTitle("My Schedule")
        }
    }
}

#Preview {
    ScheduleView()
        .modelContainer(for: Schedule.self, inMemory: true)
} 