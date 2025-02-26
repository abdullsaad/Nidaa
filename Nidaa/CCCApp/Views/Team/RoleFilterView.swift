import SwiftUI

struct RoleFilterView: View {
    @Binding var selectedRole: UserRole?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    title: "All",
                    isSelected: selectedRole == nil
                ) {
                    selectedRole = nil
                }
                
                ForEach(UserRole.allCases, id: \.self) { role in
                    FilterChip(
                        title: role.rawValue.capitalized,
                        isSelected: selectedRole == role
                    ) {
                        selectedRole = role
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(.systemGroupedBackground))
    }
} 