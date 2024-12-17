import Foundation
import CoreData
import UIKit

class DatabaseManager {
    static let shared = DatabaseManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "RecipeModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Generic CRUD Methods
    func save<T: NSManagedObject>(_ objectType: T.Type, configure: (T) -> Void) {
        let context = persistentContainer.viewContext
        let entity = T(context: context)
        
        configure(entity)
        
        do {
            try context.save()
            print("\(T.self) saved to Core Data")
        } catch {
            print("Failed to save \(T.self): \(error.localizedDescription)")
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil) -> [T] {
        let context = persistentContainer.viewContext
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest) as? [T] ?? []
        } catch {
            print("Failed to fetch \(T.self): \(error.localizedDescription)")
            return []
        }
    }
    func deleteAll<T: NSManagedObject>(_ objectType: T.Type) {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
            print("All \(T.self) objects deleted from Core Data")
        } catch {
            print("Failed to delete all \(T.self) objects: \(error.localizedDescription)")
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved")
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }
}
