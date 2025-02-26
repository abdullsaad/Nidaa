import SwiftUI
import Foundation
import CallKit
import AVFoundation

@MainActor
final class CallCoordinator: ObservableObject {
    static let shared = CallCoordinator()
    
    @Published var activeCall: NidaaCall?
    @Published var showingIncomingCall = false
    @Published var incomingCall: NidaaCall?
    
    private let callController = CXCallController()
    private var userManager = UserManager.shared
    
    private init() {}
    
    func startCall(with user: User, type: NidaaCallType) {
        // Get current user ID
        guard let currentUser = userManager.getCurrentUser() else {
            print("Error: No current user set")
            return
        }
        
        let currentUserId = currentUser.id
        
        // Create a new call
        let call = NidaaCall(
            initiatorId: currentUserId,
            recipientId: user.id,
            type: type
        )
        
        // Store the call
        activeCall = call
        
        // Create a call request
        let handle = CXHandle(type: .generic, value: user.fullName)
        let startCallAction = CXStartCallAction(call: call.uuid, handle: handle)
        
        // Configure the action
        startCallAction.isVideo = type == .video
        
        // Create a transaction
        let transaction = CXTransaction(action: startCallAction)
        
        // Request the call
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting call: \(error.localizedDescription)")
            } else {
                print("Call requested successfully")
            }
        }
    }
    
    func handleIncomingCall(_ call: NidaaCall) {
        incomingCall = call
        showingIncomingCall = true
    }
    
    func acceptIncomingCall() {
        guard let call = incomingCall else { return }
        activeCall = call
        showingIncomingCall = false
        incomingCall = nil
    }
    
    func rejectIncomingCall() {
        incomingCall = nil
        showingIncomingCall = false
    }
    
    func endCurrentCall() {
        guard let call = activeCall else {
            print("No active call to end")
            return
        }
        
        // Create an end call action
        let endCallAction = CXEndCallAction(call: call.uuid)
        
        // Create a transaction
        let transaction = CXTransaction(action: endCallAction)
        
        // Request to end the call
        callController.request(transaction) { error in
            if let error = error {
                print("Error ending call: \(error.localizedDescription)")
            } else {
                print("Call ended successfully")
                Task { @MainActor in
                    self.activeCall = nil
                }
            }
        }
    }
}

// Define our own call model to avoid conflicts
struct NidaaCall {
    enum Status {
        case connecting
        case active
        case ended
    }
    
    let uuid: UUID
    let initiatorId: UUID
    let recipientId: UUID
    var status: Status = .connecting
    var type: NidaaCallType
    
    init(initiatorId: UUID, recipientId: UUID, type: NidaaCallType) {
        self.uuid = UUID()
        self.initiatorId = initiatorId
        self.recipientId = recipientId
        self.type = type
    }
}

// Renamed to avoid conflicts
enum NidaaCallType {
    case audio
    case video
} 