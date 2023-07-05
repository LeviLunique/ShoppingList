import CoreData

public class PersistenceController {
    public static let shared = PersistenceController()

    public let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Erro ao inicializar o Core Data: \(error), \(error.userInfo)")
            }
        })
    }
    
    public convenience init(testing: Bool = false) {
        self.init(inMemory: testing)
    }
}

