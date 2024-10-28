//
//  LocalStorage.swift
//  DatePicker+Popups
//
//  Created by Ankita Kotadiya on 27/10/24.
//

import Foundation

class LocalStorage {
    static let shared = LocalStorage()
    
    private init() {}
    
    enum Keys: String {
        case userID = "UserID"
    }
    
    func setValue<T>(_ value: T, for key: Keys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    func getValue<T>(for key: Keys, defaultValue: T) -> T {
        return UserDefaults.standard.value(forKey: key.rawValue) as? T ?? defaultValue
    }
    
    var setUserID: String {
        get {
            return getValue(for: .userID, defaultValue: "")
        }
        
        set {
            setValue(newValue, for: .userID)
        }
    }
}
