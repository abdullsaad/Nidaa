import SwiftUI
import SwiftData

struct ScheduleRowView: View {
    let schedule: Schedule
    @Query private var users: [User]
    
    private var user: User? {
        users.first { $0.id == schedule.userId }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let user = user {
                UserAvatarView(user: user)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.fullName)
                        .font(.headline)
                    
                    Text(schedule.type.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
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

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Schedule.self, configurations: config)
    
    let user = User(
        firstName: "John",
        lastName: "Doe",
        email: "john@example.com",
        role: .doctor
    )
    
    let schedule = Schedule(
        userId: user.id,
        date: Date(),
        type: .day
    )
    
    return ScheduleRowView(schedule: schedule)
        .modelContainer(container)
} 