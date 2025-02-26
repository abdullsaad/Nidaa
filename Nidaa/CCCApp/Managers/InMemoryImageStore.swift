import Foundation
import UIKit

// A simple in-memory image store
class InMemoryImageStore {
    static let shared = InMemoryImageStore()
    
    private var imageStore: [String: UIImage] = [:]
    
    private init() {}
    
    // Store an image and return a unique ID
    func storeImage(_ image: UIImage) -> String {
        let id = UUID().uuidString
        imageStore[id] = image
        print("Stored image with ID: \(id)")
        return id
    }
    
    // Retrieve an image by ID
    func getImage(id: String) -> UIImage? {
        let image = imageStore[id]
        print("Retrieved image with ID: \(id), exists: \(image != nil)")
        return image
    }
    
    // Remove an image from the store
    func removeImage(id: String) {
        imageStore.removeValue(forKey: id)
        print("Removed image with ID: \(id)")
    }
} 