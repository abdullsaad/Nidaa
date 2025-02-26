import SwiftUI

struct CallTopBarView: View {
    let call: Call
    @Binding var showingEndCallConfirmation: Bool
    @State private var isCameraFlipped = false
    
    var body: some View {
        HStack {
            // Minimize button
            Button(action: { showingEndCallConfirmation = true }) {
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .symbolEffect(.bounce, options: .repeat(3))
                    .foregroundColor(.white)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Call quality indicator
            CallQualityIndicator(quality: .good)
            
            if call.type == .video {
                // Camera switch button
                Button(action: { isCameraFlipped.toggle() }) {
                    Image(systemName: "camera.rotate")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
    }
}

struct CallQualityIndicator: View {
    enum Quality {
        case excellent
        case good
        case poor
        
        var color: Color {
            switch self {
            case .excellent: return .green
            case .good: return .yellow
            case .poor: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .excellent: return "wifi"
            case .good: return "wifi"
            case .poor: return "wifi.slash"
            }
        }
    }
    
    let quality: Quality
    
    var body: some View {
        Image(systemName: quality.icon)
            .foregroundStyle(quality.color)
            .font(.caption)
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
    }
} 