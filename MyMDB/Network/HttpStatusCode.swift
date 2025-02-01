//
//  HttpStatusCode.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import Foundation

enum HttpStatusCode: Int {
    case badRequest = 400
    case invalidToken = 401
    case forbidden = 403
    case notFound = 404
    case tooManyRequests = 429
    case serverError = 500
    case serviceUnavailable = 503
    case timeout = 504

    var message: String {
        switch self {
        case .badRequest:
            return AC.badRequest
        case .invalidToken:
            return AC.invalidToken
        case .forbidden:
            return AC.forbidden
        case .notFound:
            return AC.notFound
        case .tooManyRequests:
            return AC.tooManyRequests
        case .serverError:
            return AC.serverError
        case .serviceUnavailable:
            return AC.serviceUnavailable
        case .timeout:
            return AC.timeOut
        }
    }
}
