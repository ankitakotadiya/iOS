//
//  DataBaseManager.swift
//  DatePicker+Popups
//
//  Created by Ankita Kotadiya on 27/10/24.
//

import Foundation
import CoreData

protocol CoredataManager: AnyObject {
    var viewContext: NSManagedObjectContext {get}
    func saveContext() async throws
    func delete<T: NSManagedObject>(entity: T) async throws
    func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, desriptor: [NSSortDescriptor]) -> [T]
}

final class DataBaseManager: CoredataManager {
    static let shared = DataBaseManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DatePicker")
        container.loadPersistentStores { persistentStore, error in
            if let error = error {
                fatalError("Unresolved error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() async throws {
        if viewContext.hasChanges {
            try await viewContext.perform {
                do {
                    try self.viewContext.save()
                } catch {
                    throw error
                }
            }
        }
    }
    
    func delete<T: NSManagedObject>(entity: T) async throws {
        viewContext.delete(entity)
        try await self.saveContext()
    }
    
    func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, desriptor: [NSSortDescriptor] = []) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = desriptor
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
}
