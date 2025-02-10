//
//  Movie.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import Foundation
//MARK: Search, Trend API
struct SearchAndTrendingResponse: Decodable {
    let results: [MovieInfo]
    let total_pages: Int
}

struct MovieInfo: Decodable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
    let release_date: String?
    let vote_average: Double?
    let genre_ids: [Int]?
}
//MARK: Image API
struct ImageResponse: Decodable {
    let backdrops: [ImageInfo]
    let posters: [ImageInfo]
}

struct ImageInfo: Decodable {
    let aspect_ratio: Double
    let file_path: String
}
//MARK: Credit API
struct CreditResponse: Decodable {
    let cast: [CastInfo]
}

struct CastInfo: Decodable {
    let original_name: String?
    let profile_path: String?
    let character: String?
}
