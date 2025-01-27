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
    
    func get<T>(_ key: String, _ defaultValue: T) -> T {
        defaults.object(forKey: key) as? T ?? defaultValue
    }
    
}
