//
//  Movie.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import Foundation

struct Movies: Codable {
    let results: [Results]
    let total_pages: Int
}

struct Results: Codable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
    let release_date: String?
    let vote_average: Double?
    let genre_ids: [Int]?
}

struct Images: Codable {
    let backdrops: [ImageInfo]
    let posters: [ImageInfo]
}

struct ImageInfo: Codable {
    let aspect_ratio: Double
    let file_path: String
}
