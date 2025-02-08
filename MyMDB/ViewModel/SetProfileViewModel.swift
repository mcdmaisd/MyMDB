//
//  SetProfileViewModel.swift
//  MyMDB
//
//  Created by ilim on 2025-02-08.
//

import Foundation

class SetProfileViewModel {
    //input
    let profileImageInput: Observable<String?> = .init(nil)
    let nicknameInput = Observable("")
    let dateInput = Observable("")
    let mbtiInput: Observable<Int?> = .init(nil)
    //output
    let profileImage = Observable(U.shared.get(C.profileImageKey, C.randomProfileImage))
    let nickname = Observable("")
    let status = Observable("")
    let collectionViewReload = Observable(())
    let changeRootView = Observable(())
    let saveButtonHidden: Observable<Bool> = .init(false)
    
    var mbti = U.shared.get(C.mbtiKey, C.defaultKey)
    
    init() {
        profileImageInput.bind { [weak self] name in
            guard let name else { return }
            self?.profileImage.value = name
        }
        
        mbtiInput.bind { [weak self] index in
            guard let index else { return }
            self?.toggleKey(index)
        }
    }
    
    private func toggleKey(_ index: Int) {
        guard let index = mbtiInput.value else { return }
        let pairIndex = index < 4 ? index + 4 : index - 4
        mbti[index].toggle()
        mbti[pairIndex] = false
        collectionViewReload.value = ()
    }
    
    private func checkNickname() {
        
    }
    
}
