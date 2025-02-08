//
//  Constants.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import Foundation

struct Constants {
    private init() { }
    
    static let sizeXs: CGFloat = 12
    static let sizeSm: CGFloat = 13
    static let sizeMd: CGFloat = 14
    static let sizeLg: CGFloat = 15
    static let sizeXl: CGFloat = 16
    
    static let unselectedBorderWidth: CGFloat = 1
    static let selectedBorderWidth: CGFloat = 3
    static let unselectedAlpha: CGFloat = 0.5
    static let selectedAlpha: CGFloat = 1
    static let stackViewSpacing: CGFloat = 5
    static let cornerRadius: CGFloat = 10
    static let tableViewCellInset: CGFloat = 20
    static let tableViewCellHeight: CGFloat = 40
    static let estimatedHeight: CGFloat = 100
    
    static let profileImageCount = 12
    
    static let range = 0...11
    
    static let settingTitles = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
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
    static let infoStackImages = [calendar, star, filmFill]
    static let forward = "chevron.forward"
    static let backward = "chevron.backward"
    static let dismissKeyboardImage = "keyboard.chevron.compact.down"
    static let profileImagePrefix = "profile_"
    static let randomProfileImage = "\(profileImagePrefix)\(Int.random(in: range))"
    
    static let setProfileTitle = "프로필 설정"
    static let setProfileImageTitle = "프로필 이미지 설정"
    static let editProfileTitle = "프로필 편집"
    static let editProfileImgaeTitle = "프로필 이미지 편집"
    static let main = "메인"
    static let searchMovieTitle = "영화 검색"
    static let settingTitle = "설정"
    static let save = "저장"

    static let done = "Done"
    static let appName = "MyMovieDB"
    static let onboarding = "Onboarding"
    
    static let description = "당신만의 영화 세상,\n\(appName)를 시작해보세요."
    static let start = "시작하기"
    static let completion = "완료"
    static let savedMovieCountSuffix = " 개의 무비박스 보관중"
    static let nicknamePlaceholder = "닉네임을 입력해 주세요"
    
    static let validNickname = "사용할 수 있는 닉네임이에요"
    static let invalidLength = "2글자 이상 10글자 미만으로 설정해 주세요"
    static let invalidCharacter = "닉네임에 @, #, $, % 는 포함할 수 없어요"
    static let invalidNumber = "닉네임에 숫자는 포함할 수 없어요"
    static let invalidCharacterSet = "@#$%"
    static let newline = "\n"
    static let slash = "/"
    
    static let firstKey = "first"
    static let profileImageKey = "profileImage"
    static let nickNameKey = "nickName"
    static let movieCountKey = "movieCount"
    static let searchHistoryKey = "searchHistory"
    static let dateKey = "date"
    static let mbtiKey = "mbti"
    
    static let alertTitle = "탈퇴하기"
    static let alertMessage = "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?"
    static let okActionTitle = "확인"
    static let cancelActionTitle = "취소"
    
    static let dateStringFormat = "yy.MM.dd '가입'"
    static let locale = "ko_KR"
    static let failure = "Fail"
    static let nilValue = "nil"

    static let userInfoChanged = "changed"
    static let userInfoKey = "key"
    
    static let recentSearches = "최근검색어"
    static let todayMovie = "오늘의 영화"
    static let synopsis = "Synopsis"
    static let sectionHeaders = ["Cast", "Poster"]
    static let emptyHeaderMessage = [noCast, noPoster]
    
    static let removeAll = "전체 삭제"
    static let more = "More"
    static let hide = "Hide"
    static let emptyHistory = "최근 검색어 내역이 없습니다."
    static let searchBarPlaceHolder = "영화를 검색해보세요"
    static let emptyMessage = "검색어를 최소 1자 이상 입력해주세요"
    static let emptyOverView = "상세설명이 제공되지 않습니다."
    static let emptySearchResult = "원하는 검색결과를 찾지 못했습니다"
    static let noCast = "배우 목록이 제공되지 않습니다."
    static let noPoster = "포스터 이미지가 제공되지 않습니다."
    static let noInfo = "정보 없음"
    static let likeButtonMessages = [true: "영화가 무비박스에 보관되었습니다.", false: "영화가 무비박스에서 삭제되었습니다."]
    static let queueLabel = "monitor"
    static let MBTITitle = "MBTI"
    static let MBTIs = ["ESTJ", "INFP"]
    static let MBTIKey = ["E", "S", "T", "J", "I", "N ", "F", "P"]
    static let defaultKey = [Bool](repeating: false, count: 8)

}
