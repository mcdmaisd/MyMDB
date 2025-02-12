//
//  ErrorString.swift
//  MyMDB
//
//  Created by ilim on 2025-02-12.
//

import UIKit

class ErrorAlert {
    static let shared = ErrorAlert()
    
    var statusCode: Int? {
        didSet {
            errorAlert()
        }
    }

    private init() { }
    
    private func errorAlert() {
        guard
            let statusCode,
            let errorMessage = HttpStatusCode(rawValue: statusCode)?.message
        else { return }
        
        showAlert(errorMessage)
    }
}
