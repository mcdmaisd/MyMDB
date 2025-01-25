//
//  UserDefaultsManager.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import Foundation

final public class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private init() { }
    
    func set(_ value: Any, _ key: String) {
        defaults.setValue(value, forKey: key)
    }
    
    func get(_ key: String) -> Any? {
        defaults.object(forKey: key)
    }
    
}
