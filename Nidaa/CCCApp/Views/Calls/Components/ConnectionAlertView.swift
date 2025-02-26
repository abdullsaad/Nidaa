import SwiftUI

struct ConnectionAlertView: View {
    @State private var isConnected = true
    
    var body: some View {
        VStack {
            Text("Connection Issue")
                .font(.headline)
                .foregroundColor(.red)
            
            Text(isConnected ? "Connected" : "No Connection")
                .font(.subheadline)
                .foregroundColor(isConnected ? .green : .gray)
        }
        .padding()
        .background(Color.yellow.opacity(0.3))
        .cornerRadius(8)
    }
}

#Preview {
    ConnectionAlertView()
} 