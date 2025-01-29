//
//  APIConstants.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import Foundation

public struct APIConstants {
    private init() { }
    //MARK: genreDictionary
    static let genreDictionary: [Int: String] = [
        12: "모험",
        14: "판타지",
        16: "애니메이션",
        18: "드라마",
        27: "공포",
        28: "액션",
        35: "코미디",
        36: "역사",
        37: "서부",
        53: "스릴러",
        80: "범죄",
        99: "다큐멘터리",
        878: "SF",
        9648: "미스터리",
        10402: "음악",
        10749: "로맨스",
        10751: "가족",
        10752: "전쟁",
        10770: "TV 영화"
    ]
    //MARK: page
    static let firstPage = 1
    //MARK: separator
    static let separator = "/"
    //MARK: url
    static let baseURL = "https://api.themoviedb.org/3/"
    static let baseImageURL = "https://image.tmdb.org/t/p/original"
    //MARK: path
    static let trending = "trending"
    static let movie = "movie"
    static let day = "day"
    static let search = "search"
    static let images = "images"
    static let credits = "credits"
    //MARK: parameter
    static let language = "language"
    static let locale = "ko-KR"
    static let page = "page"
    static let query = "query"
    static let adult = "include_adult"
    //MARK: header
    static let headerKey = "Authorization"
    static let headerValuePrefix = "Bearer "
}
