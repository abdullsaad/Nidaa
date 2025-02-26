import Foundation
import SwiftData
import UIKit

@MainActor
final class MessageManager: ObservableObject {
    static let shared = MessageManager()
    
    @Published var conversations: [Conversation] = []
    @Published var selectedConversation: Conversation?
    
    private var modelContext: ModelContext?
    private var userManager = UserManager.shared
    
    private init() {}
    
    func initialize(with context: ModelContext) {
        self.modelContext = context
        loadConversations()
    }
    
    func loadConversations() {
        guard let modelContext = modelContext else { return }
        
        // Get current user
        guard let currentUser = userManager.getCurrentUser() else {
            print("Error: No current user set")
            return
        }
        
        let currentUserId = currentUser.id
        
        do {
            // Fetch all messages involving the current user
            let descriptor = FetchDescriptor<Message>(
                predicate: #Predicate<Message> { message in
                    message.senderId == currentUserId || message.recipientId == currentUserId
                },
                sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
            )
            
            let messages = try modelContext.fetch(descriptor)
            
            // Group messages by conversation
            var conversationDict: [UUID: Conversation] = [:]
            
            for message in messages {
                let otherUserId = message.senderId == currentUserId ? message.recipientId : message.senderId
                
                if let conversation = conversationDict[otherUserId] {
                    conversation.messages.append(message)
                } else {
                    let newConversation = Conversation(otherUserId: otherUserId, messages: [message])
                    conversationDict[otherUserId] = newConversation
                }
            }
            
            // Convert to array and sort by most recent message
            conversations = Array(conversationDict.values).sorted { conv1, conv2 in
                guard let lastMessage1 = conv1.messages.first, let lastMessage2 = conv2.messages.first else {
                    return false
                }
                return lastMessage1.timestamp > lastMessage2.timestamp
            }
            
        } catch {
            print("Error loading conversations: \(error.localizedDescription)")
        }
    }
    
    func sendMessage(to recipientId: UUID, content: String, attachments: [Attachment] = []) {
        guard let modelContext = modelContext else { return }
        
        // Get current user
        guard let currentUser = userManager.getCurrentUser() else {
            print("Error: No current user set")
            return
        }
        
        let currentUserId = currentUser.id
        
        // Create new message
        let message = Message(
            senderId: currentUserId,
            recipientId: recipientId,
            content: content,
            attachments: attachments,
            status: .sent,
            timestamp: Date()
        )
        
        // Save to database
        modelContext.insert(message)
        
        do {
            try modelContext.save()
            
            // Update conversations
            if let index = conversations.firstIndex(where: { $0.otherUserId == recipientId }) {
                conversations[index].messages.insert(message, at: 0)
            } else {
                let newConversation = Conversation(otherUserId: recipientId, messages: [message])
                conversations.insert(newConversation, at: 0)
            }
            
            // Update selected conversation if needed
            if selectedConversation?.otherUserId == recipientId {
                selectedConversation?.messages.insert(message, at: 0)
            }
            
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
    func sendEmergencyMessage(to recipientId: UUID, about alert: Alert) {
        let content = if let location = alert.location {
            "Emergency Alert: \(alert.message) at \(location)"
        } else {
            "Emergency Alert: \(alert.message)"
        }
        
        sendMessage(
            to: recipientId,
            content: content,
            attachments: []
        )
    }
    
    func markAsRead(_ message: Message) throws {
        message.readTimestamp = Date()
        try modelContext?.save()
    }
    
    func deleteMessage(_ message: Message) throws {
        modelContext?.delete(message)
        try modelContext?.save()
    }
    
    func sendImage(_ image: UIImage, to recipientId: UUID) {
        guard let modelContext = modelContext else { return }
        
        // Store image in our simple shared cache
        let imageID = SharedImageCache.shared.storeImage(image)
        SharedImageCache.shared.printCacheContents()
        
        // Create a placeholder URL
        let placeholderURL = URL(string: "memory://\(imageID)")!
        
        // Create attachment
        let attachment = Attachment(
            type: .image,
            url: placeholderURL,
            name: "image.jpg",
            size: 0,
            mimeType: "image/jpeg",
            imageID: imageID
        )
        
        // Insert attachment into database
        modelContext.insert(attachment)
        
        // Send message with attachment
        sendMessage(
            to: recipientId,
            content: "",
            attachments: [attachment]
        )
    }
    
    func sendImages(_ images: [UIImage], to recipientId: UUID) {
        guard let modelContext = modelContext else { return }
        
        var attachments: [Attachment] = []
        
        // Store all images
        for image in images {
            // Store image in our robust ImageStore
            let imageID = ImageStore.shared.storeImage(image)
            
            // Create a placeholder URL
            let placeholderURL = URL(string: "image://\(imageID)")!
            
            // Create attachment
            let attachment = Attachment(
                type: .image,
                url: placeholderURL,
                name: "image.jpg",
                size: 0,
                mimeType: "image/jpeg",
                imageID: imageID
            )
            
            modelContext.insert(attachment)
            attachments.append(attachment)
        }
        
        // Send a single message with all attachments
        sendMessage(
            to: recipientId,
            content: "",
            attachments: attachments
        )
    }
}

enum MessageError: Error {
    case noContext
    case failedToSaveImage
}

// Helper class to represent a conversation
class Conversation: Identifiable, ObservableObject {
    let id = UUID()
    let otherUserId: UUID
    @Published var messages: [Message]
    
    init(otherUserId: UUID, messages: [Message]) {
        self.otherUserId = otherUserId
        self.messages = messages
    }
} 