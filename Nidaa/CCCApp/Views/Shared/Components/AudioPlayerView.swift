import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    let url: URL
    @StateObject private var player = AudioPlayer()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform")
                .font(.system(size: 50))
                .foregroundColor(.accentColor)
            
            HStack(spacing: 20) {
                Button {
                    if player.isPlaying {
                        player.pause()
                    } else {
                        player.play()
                    }
                } label: {
                    Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.accentColor)
                }
            }
        }
        .onAppear {
            player.setup(with: url)
        }
        .onDisappear {
            player.stop()
        }
    }
} 