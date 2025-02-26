import Foundation
import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    // Save image to documents directory and return the file URL
    func saveImage(_ image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            print("Failed to convert image to JPEG data")
            return nil
        }
        
        let fileName = "\(UUID().uuidString).jpg"
        let fileURL = FileManager.default.documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            print("Successfully saved image to: \(fileURL.path)")
            return fileURL
        } catch {
            print("Failed to write image to disk: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Load image from file URL
    func loadImage(from url: URL) -> UIImage? {
        print("Loading image from: \(url.path)")
        
        do {
            let data = try Data(contentsOf: url)
            print("Successfully loaded \(data.count) bytes of image data")
            
            if let image = UIImage(data: data) {
                print("Successfully created UIImage")
                return image
            } else {
                print("Failed to create UIImage from data")
                return nil
            }
        } catch {
            print("Error loading image data: \(error.localizedDescription)")
            return nil
        }
    }
} 