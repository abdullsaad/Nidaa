import Foundation
import UIKit

// A robust image storage solution that combines in-memory and disk storage
class ImageStore {
    static let shared = ImageStore()
    
    // In-memory cache
    private var imageCache: [String: UIImage] = [:]
    
    private init() {}
    
    // Store an image both in memory and on disk
    func storeImage(_ image: UIImage) -> String {
        let id = UUID().uuidString
        
        // Store in memory cache
        imageCache[id] = image
        
        // Also save to disk as backup
        saveImageToDisk(image, withID: id)
        
        print("Stored image with ID: \(id) in memory and on disk")
        return id
    }
    
    // Get image - first try memory, then disk
    func getImage(id: String) -> UIImage? {
        // First check memory cache
        if let cachedImage = imageCache[id] {
            print("Retrieved image with ID: \(id) from memory cache")
            return cachedImage
        }
        
        // If not in memory, try loading from disk
        if let diskImage = loadImageFromDisk(withID: id) {
            // Add back to memory cache
            imageCache[id] = diskImage
            print("Retrieved image with ID: \(id) from disk")
            return diskImage
        }
        
        print("Image with ID: \(id) not found in memory or disk")
        return nil
    }
    
    // Save image to disk
    private func saveImageToDisk(_ image: UIImage, withID id: String) {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            print("Failed to convert image to JPEG data")
            return
        }
        
        let fileURL = getFileURL(forID: id)
        
        do {
            try data.write(to: fileURL)
            print("Successfully saved image to disk at: \(fileURL.path)")
        } catch {
            print("Failed to write image to disk: \(error.localizedDescription)")
        }
    }
    
    // Load image from disk
    private func loadImageFromDisk(withID id: String) -> UIImage? {
        let fileURL = getFileURL(forID: id)
        
        do {
            let data = try Data(contentsOf: fileURL)
            print("Successfully loaded \(data.count) bytes from disk")
            
            if let image = UIImage(data: data) {
                print("Successfully created UIImage from disk data")
                return image
            } else {
                print("Failed to create UIImage from disk data")
                return nil
            }
        } catch {
            print("Failed to load image from disk: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Get file URL for an image ID
    private func getFileURL(forID id: String) -> URL {
        let documentsDirectory = FileManager.default.documentsDirectory
        return documentsDirectory.appendingPathComponent("\(id).jpg")
    }
    
    // Add this method to the ImageStore class
    func debugPrintAllStoredImages() {
        print("--- ImageStore Contents ---")
        print("Memory cache contains \(imageCache.count) images")
        for (id, _) in imageCache {
            print("Image ID in memory: \(id)")
        }
        
        // Check disk storage
        let documentsDirectory = FileManager.default.documentsDirectory
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            let imageURLs = fileURLs.filter { $0.pathExtension == "jpg" }
            print("Disk storage contains \(imageURLs.count) images")
            for url in imageURLs {
                print("Image on disk: \(url.lastPathComponent)")
            }
        } catch {
            print("Error checking disk storage: \(error)")
        }
        print("-------------------------")
    }
} 