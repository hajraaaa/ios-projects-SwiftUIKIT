import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Authentication_in_Swift")
        
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveUserCredentials(email: String, password: String, name: String, profileimage: Data) {
        let newUser = Users(context: context)
        newUser.email = email
        newUser.password = password
        newUser.name = name
        newUser.profileimage = profileimage
        
        do {
            try context.save()
            print("User saved successfully!")
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    func fetchUser(byEmail email: String) -> Users? {
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }
    
    func saveUserProfileImage(_ imageData: Data, forEmail email: String) {
        if let user = fetchUser(byEmail: email) {
            user.profileimage = imageData
            do {
                try context.save()
                print("Profile image saved successfully!")
            } catch {
                print("Failed to save profile image: \(error)")
            }
        } else {
            print("User not found with email: \(email)")
        }
    }
    
    // MARK: - Session Management
    func createSession(for userId: UUID, deviceId: String) {
        let session = Session(context: context)
        session.deviceId = deviceId
        session.isLoggedIn = true
        session.loginTimestamp = Date()
//        session.userId = userId
        
        do {
            try context.save()
            print("Session created successfully!")
        } catch {
            print("Failed to create session: \(error)")
        }
    }

    func fetchActiveSession() -> Session? {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLoggedIn == %@", NSNumber(value: true))
        
        do {
            let sessions = try context.fetch(fetchRequest)
            return sessions.first
        } catch {
            print("Failed to fetch active session: \(error)")
            return nil
        }
    }

    func endSession() {
        if let activeSession = fetchActiveSession() {
            activeSession.isLoggedIn = false
            do {
                try context.save()
                print("Session ended successfully!")
            } catch {
                print("Failed to end session: \(error)")
            }
        } else {
            print("No active session found.")
        }
    }
}
