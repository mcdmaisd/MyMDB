//
//  UserDefaultsManager.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import Foundation

final public class UserDefaultsManager {//제네릭 이용해서 type casting 처리 할것
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
