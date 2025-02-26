import Foundation
import AVFoundation

@MainActor
final class CallManager: ObservableObject {
    static let shared = CallManager()
    
    @Published private(set) var activeCall: Call?
    @Published private(set) var isMuted = false
    @Published private(set) var isSpeakerOn = false
    
    private init() {}
    
    func startCall(_ call: Call) async {
        activeCall = call
    }
    
    func endCall() async {
        activeCall = nil
    }
    
    func toggleMute() {
        isMuted.toggle()
    }
    
    func toggleSpeaker() {
        isSpeakerOn.toggle()
    }
} 