//
//  Movie.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import Foundation

struct Trending: Codable {
    let results: [Results]
}

struct Results: Codable {
    let id: Int
    var backdrop_path: String
    var title: String
    var overview: String
    var poster_path: String
    var genre_ids: [Int]
    var release_date: String
    var vote_average: Double
}
