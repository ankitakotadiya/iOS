import Foundation
import RealmSwift


protocol RealmManageable {
    func save<T: Object>(objects: [T])
    func fetchAll<T: Object>(_ type: T.Type) -> [T]?
    func updateObject<T: Object>(withPrimaryKey key: Any, update: (T) -> Void)
    func fetchObjects<T: Object>(ofType type: T.Type, with predicate: NSPredicate) -> [T]?
    func realmInstance() -> Realm
}

final class RealmManager: RealmManageable {
//    static let shared = RealmManager()
//    let realm: Realm
    
    init() {
        // Setup the Realm configuration with a migration block
        let config = Realm.Configuration(
            schemaVersion: 2, // Increment this whenever your schema changes
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // Perform migrations as necessary
                    // Example migration for `Article` class if needed
                    migration.enumerateObjects(ofType: Article.className()) { oldObject, newObject in
                        // Perform migration if requires
                    }
                }
            }
        )
        
        // Apply the configuration
        Realm.Configuration.defaultConfiguration = config
        
        // Initialize the Realm instance
        //            realm = try Realm()
    }
    
    func realmInstance() -> Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    func save<T: Object>(objects: [T]) {
        let realm = realmInstance()
        _ = try? realm.write {
            realm.add(objects, update: .all)
        }
    }
    
    func fetchAll<T: Object>(_ type: T.Type) -> [T]? {
        let realm = realmInstance()
        let allObjects = realm.objects(T.self)
        return Array(allObjects)
    }
    
    func updateObject<T: Object>(withPrimaryKey key: Any, update: (T) -> Void) {
        let realm = realmInstance()
        do {
            guard let object = realm.object(ofType: T.self, forPrimaryKey: key) else {
                return
            }
            
            try realm.write {
                update(object)
            }
        } catch {
            fatalError("Error updating object: \(error.localizedDescription)")
        }
    }
    
    func fetchObjects<T: Object>(ofType type: T.Type, with predicate: NSPredicate) -> [T]? {
        let realm = realmInstance()
        let filteredObjects = realm.objects(type).filter(predicate)
        return Array(filteredObjects)
    }
}
