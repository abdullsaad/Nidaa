import SwiftUI

struct CallControlButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.black)
                .frame(width: 50, height: 50)
                .background(color)
                .clipShape(Circle())
        }
    }
} 