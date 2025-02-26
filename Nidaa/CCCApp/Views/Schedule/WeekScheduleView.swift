import SwiftUI

struct WeekScheduleView: View {
    let schedules: [Schedule]
    
    var body: some View {
        List {
            ForEach(schedules) { schedule in
                ScheduleRowView(schedule: schedule)
            }
        }
    }
} 