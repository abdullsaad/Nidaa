import Foundation
import SwiftData

@MainActor
final class ModelManager: ObservableObject {
    static let shared = ModelManager()
    
    private var context: ModelContext?
    var modelContainer: ModelContainer?
    
    private init() {}
    
    func setModelContext(_ context: ModelContext) {
        self.context = context
    }
    
    func setModelContainer(_ container: ModelContainer) {
        self.modelContainer = container
    }
    
    func getModelContext() -> ModelContext? {
        return context
    }
} 