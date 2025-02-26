import Foundation
import AVFoundation

@MainActor
final class VideoCallManager: ObservableObject {
    static let shared = VideoCallManager()
    
    @Published var isCameraOn = true
    @Published var isUsingFrontCamera = true
    
    private init() {}
    
    func toggleCamera() {
        isCameraOn.toggle()
    }
    
    func switchCamera() {
        isUsingFrontCamera.toggle()
    }
} 