import SwiftUI

struct CallRecordingView: View {
    @State private var isRecording = false
    @State private var recordingDuration: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 8) {
            // Recording indicator
            HStack(spacing: 8) {
                Circle()
                    .fill(.red)
                    .frame(width: 8, height: 8)
                    .opacity(isRecording ? 1 : 0)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: isRecording)
                
                Text(isRecording ? "Recording" : "Start Recording")
                    .font(.caption)
                    .foregroundColor(.white)
                
                if isRecording {
                    Text(recordingDuration.formattedTime)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .onTapGesture {
                toggleRecording()
            }
        }
    }
    
    private func toggleRecording() {
        isRecording.toggle()
        
        if isRecording {
            startRecordingTimer()
        } else {
            stopRecordingTimer()
            // Save recording logic here
        }
    }
    
    private func startRecordingTimer() {
        recordingDuration = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            recordingDuration += 1
        }
    }
    
    private func stopRecordingTimer() {
        timer?.invalidate()
        timer = nil
    }
} 