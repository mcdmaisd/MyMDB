//
//  Movie.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import Foundation
//MARK: Search, Trend API
struct TMDBSearchAndTrendingResponse: Decodable {
    let results: [TMDBMovieInfo]
    let total_pages: Int
}

struct TMDBMovieInfo: Decodable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
    let release_date: String?
    let vote_average: Double?
    let genre_ids: [Int]?
}
//MARK: Image API
struct TMDBImageResponse: Decodable {
    let backdrops: [TMDBImageInfo]
    let posters: [TMDBImageInfo]
}

struct TMDBImageInfo: Decodable {
    let aspect_ratio: Double
    let file_path: String
}
//MARK: Credit API
struct TMDBCreditResponse: Decodable {
    let cast: [TMDBCastInfo]
}

struct TMDBCastInfo: Decodable {
    let original_name: String?
    let profile_path: String?
    let character: String?
}
