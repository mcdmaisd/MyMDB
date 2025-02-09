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
    let nicknameValidationMessage = Observable("")
    let collectionViewReload = Observable(())
    let changeRootView = Observable(())
    let saveButton: Observable<Bool> = .init(false)
    
    private var mbti = U.shared.get(C.mbtiKey, C.defaultKey)
    private var hasInvalidLength = false
    private var hasInvalidCharacter = false
    private var hasInvalidMBTI = false
    private var hasNumber = false
    private var result = false
    private var isValidNickname = false
    private var isValidMbti = false
    
    init() {
        profileImageInput.bind { [weak self] name in
            guard let name else { return }
            self?.profileImage.value = name
        }
        
        nicknameInput.bind { [weak self] nickname in
            self?.checkNickname()
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
        checkMbti()
        collectionViewReload.value = ()
    }
    
    private func checkNickname() {
        let text = nicknameInput.value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        hasInvalidLength = text.count < 2 || text.count >= 10
        hasInvalidCharacter = !text.filter(C.invalidCharacterSet.contains).isEmpty
        hasNumber = !text.filter { $0.isNumber }.isEmpty
        result = !hasInvalidLength && !hasInvalidCharacter && !hasNumber
        
        if text.isEmpty {
            nicknameValidationMessage.value = ""
        } else if hasInvalidLength {
            nicknameValidationMessage.value = C.invalidLength
        } else if hasInvalidCharacter {
            nicknameValidationMessage.value = C.invalidCharacter
        } else if hasNumber {
            nicknameValidationMessage.value = C.invalidNumber
        } else {
            nicknameValidationMessage.value = C.validNickname
        }
        
        isValidNickname = result
        configureSaveButtonStatus()
    }
    
    private func checkMbti() {
        isValidMbti = mbti.filter { $0 == true }.count == 4
        configureSaveButtonStatus()
    }
    
    private func configureSaveButtonStatus() {
        // 닉네임, mbti 모두 충족하면 true, 그 외 false
        // 핵심은 닉네임, mbti가 각각 변경될때마다 이 함수가 실행이되어서 vc에 output 전달이 되어야함
        saveButton.value = isValidNickname && isValidMbti
    }
    
    private func save() {
        
    }
    
}
