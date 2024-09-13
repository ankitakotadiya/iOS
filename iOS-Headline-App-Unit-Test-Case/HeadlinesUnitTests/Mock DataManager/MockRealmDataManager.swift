//
//  MockRealmDataManager.swift
//  ArticlesViewModelTests
//
//  Created by Ankita Kotadiya on 05/09/24.
//  Copyright © 2024 Example. All rights reserved.
//

import Foundation
import RealmSwift
@testable import Headlines

class MockRealmDataManager: RealmManageable {
    var mockData: [Object] = []
    
    private func keyIdentifier<T>(type: T.Type) -> String {
        return String(describing: T.self)
    }
    
    func realmInstance() -> Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Realm Object is not created")
        }
    }
    
    func setMockData<T: Object>(type: T.Type, data: [T]) {
        self.mockData = data
    }
    
    func save<T>(objects: [T]) where T : Object {
        self.mockData = objects
    }
    
    func fetchAll<T: Object>(_ type: T.Type) -> [T]? {
        return mockData as? [T]
    }
    
    func updateObject<T>(withPrimaryKey key: Any, update: (T) -> Void) where T : Object {
        
        if let index = mockData.firstIndex(where: { object in
            if let primaryKey = T.primaryKey(), let primaryKeyValue = object.value(forKey: primaryKey) as? String {
                return primaryKeyValue == key as? String
            }
            return false
        }) {
            if let object = mockData[index] as? T {
                update(object)
            }
        }
    }
    
    func fetchObjects<T>(ofType type: T.Type, with predicate: NSPredicate) -> [T]? where T : Object {
        guard let objects = mockData as? [T], objects.count > 0 else { return nil }
        return objects.filter { predicate.evaluate(with: $0) }
    }
}
