//
//  APIManager.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import Foundation
import Alamofire

final class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func requestAPI<T: Decodable>(_ router: APIRouter, _ completionHandler: @escaping (T) -> Void) {
        AF.request(router).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure:
                guard let statusCode = response.response?.statusCode else { return }
                ErrorAlert.shared.statusCode = statusCode
            }
        }
    }
}
