import UIKit

// A simple global image cache that holds images in memory
class SharedImageCache {
    static let shared = SharedImageCache()
    
    private var cache: [String: UIImage] = [:]
    
    private init() {}
    
    func storeImage(_ image: UIImage) -> String {
        let id = UUID().uuidString
        cache[id] = image
        print("Stored image in SharedImageCache with ID: \(id)")
        return id
    }
    
    func getImage(id: String) -> UIImage? {
        let image = cache[id]
        print("Retrieved image from SharedImageCache with ID: \(id), exists: \(image != nil)")
        return image
    }
    
    func printCacheContents() {
        print("SharedImageCache contains \(cache.count) images")
        for id in cache.keys {
            print("- Image ID: \(id)")
        }
    }
} 