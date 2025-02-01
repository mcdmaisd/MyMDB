//
//  APIRouter.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case trending
    case search(keyword: String, page: Int)
    case image(id: Int)
    case credit(id: Int)
    
    private var baseURL: URL {
        return URL(string: AC.baseURL)!
    }
    
    private var method: HTTPMethod {
        switch self {
        case .trending, .search, .image, .credit:
            return .get
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .trending, .search, .image, .credit:
            return [AC.headerKey: "\(AC.headerValuePrefix)\(TMDB.key)"]
        }
    }
    
    private var path: String {
        switch self {
        case .trending:
            return makePath([AC.trending, AC.movie, AC.day])
        case .search:
            return makePath([AC.search, AC.movie])
        case .image(let id):
            return makePath([AC.movie, "\(id)", AC.images])
        case .credit(let id):
            return makePath([AC.movie, "\(id)", AC.credits])
        }
    }
    
    private var parameter: Parameters? {
        switch self {
        case .trending, .credit:
            return AC.baseParam
        case .search(let keyword, let page):
            let dict = [AC.query: keyword, AC.adult: AC.notInclude, AC.page: "\(page)"]
            return dict.merging(AC.baseParam) { _, _ in fatalError(AC.mergeFailed) }
        case .image:
            return nil
        }
    }
    
    private func makePath(_ path: [String]) -> String {
        return path.compactMap { $0 }.joined(separator: AC.separator)
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = header
        
        if let parameter {
            request = try URLEncoding.default.encode(request, with: parameter)
        }
        
        return request
    }
}
