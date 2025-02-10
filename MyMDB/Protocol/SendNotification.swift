//
//  SendNotification.swift
//  MyMDB
//
//  Created by ilim on 2025-02-10.
//

import Foundation

protocol SendNotification {
    func postNotification(_ name: String, _ value: Bool, _ id: Int?)
}
