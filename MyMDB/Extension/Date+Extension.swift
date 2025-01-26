//
//  String+Extension.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: C.locale)
        formatter.dateFormat = C.dateStringFormat
        
        return formatter.string(from: self)
    }
}
