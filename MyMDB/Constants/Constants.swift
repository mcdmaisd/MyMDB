//
//  Constants.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import Foundation

public struct Constants {
    
    private init() { }
    
    static let sizeXs: CGFloat = 12
    static let sizeSm: CGFloat = 13
    static let sizeMd: CGFloat = 14
    static let sizeLg: CGFloat = 15
    static let sizeXl: CGFloat = 16
    
    static let unselectedBorderWidth: CGFloat = 1
    static let selectedBorderWidth: CGFloat = 3
    static let unselectedAlpha: CGFloat = 0.5
    static let cornerRadius: CGFloat = 20
    
    static let tabbarImages = ["popcorn", "film.stack", "person.circle"]
    static let tabbarTitles = ["CINEMA", "UPCOMING", "PROFILE"]
    
    static let searchImage = "magnifyingglass"
    static let heart = "heart"
    static let heartFill = "heart.fill"
    static let xmark = "xmark"
    static let camera = "camera.fill"
    static let calendar = "calendar"
    static let star = "star.fill"
    static let filmFill = "film.fill"
    static let forward = "chevron.forward"
    static let backward = "chevron.backward"
    
    static let setProfileTitle = "프로필 설정"
    static let setProfileImageTitle = "프로필 이미지 설정"
    static let editProfileTitle = "프로필 편집"
    static let editProfileImgaeTitle = "프로필 이미지 편집"
    static let todayMovieTitle = "오늘의 영화"
    static let searchMovieTitle = "영화 검색"
    static let settingTitle = "설정"
    
    static let first = "first"
    static let okActionTitle = "확인"
    static let appName = "MyMovieDB"
    
    static let onboarding = "Onboarding"
    static let description = "당신만의 영화 세상,\n\(appName)를 시작해보세요."
    static let start = "시작하기"
    static let completion = "완료"
    static let savedMovieCountSuffix = " 개의 무비박스 보관중"
}
