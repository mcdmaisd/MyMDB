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
    let nicknameInput: Observable<String?> = .init(nil)
    let dateInput = Observable(())
    let mbtiInput: Observable<Int?> = .init(nil)
    //output
    let profileImage = Observable(U.shared.get(C.profileImageKey, C.randomProfileImage))
    let nickname = Observable(U.shared.get(C.nickNameKey, ""))
    let nicknameValidationMessage = Observable("")
    let collectionViewReload = Observable(())
    let changeRootView = Observable(())
    let saveButton: Observable<Bool> = .init(false)
    let isEdit = U.shared.get(C.firstKey, false)
    
    private(set) var mbti = U.shared.get(C.mbtiKey, C.defaultKey)
    private(set) var result = false

    private var hasInvalidLength = false
    private var hasInvalidCharacter = false
    private var hasInvalidMBTI = false
    private var hasNumber = false
    private var isValidNickname = false
    private lazy var isValidMbti = mbti.filter { $0 == true }.count == 4
    
    init() {
        profileImageInput.lazyBind { [weak self] name in
            guard let name else { return }
            self?.profileImage.value = name
        }
        
        nicknameInput.lazyBind { [weak self] nickname in
            self?.checkNickname()
        }
        
        mbtiInput.lazyBind { [weak self] index in
            guard let index else { return }
            self?.toggleKey(index)
        }
        
        dateInput.lazyBind { [weak self] _ in
            self?.save()
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
        guard let text = nicknameInput.value?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        nickname.value = text
        var errorMessage: [String?] = []

        hasInvalidLength = text.count < 2 || text.count >= 10
        hasInvalidCharacter = !text.filter(C.invalidCharacterSet.contains).isEmpty
        hasNumber = !text.filter { $0.isNumber }.isEmpty
        result = !hasInvalidLength && !hasInvalidCharacter && !hasNumber
        
        if text.isEmpty {
            errorMessage.append("")
        } else if hasInvalidLength {
            errorMessage.append(C.invalidLength)
        } else {
            errorMessage = [
                hasInvalidCharacter ? C.invalidCharacter : nil,
                hasNumber ? C.invalidNumber: nil,
                result ? C.validNickname: nil
            ]
        }
        nicknameValidationMessage.value = errorMessage.compactMap { $0 }.joined(separator: C.newline)
        isValidNickname = result
        configureSaveButtonStatus()
    }
    
    private func checkMbti() {
        isValidMbti = mbti.filter { $0 == true }.count == 4
        configureSaveButtonStatus()
    }
    
    private func configureSaveButtonStatus() {
        saveButton.value = isValidNickname && isValidMbti
    }
    
    private func save() {
        U.shared.set(profileImage.value, C.profileImageKey)
        U.shared.set(nicknameInput.value ?? "", C.nickNameKey)
        U.shared.set(mbti, C.mbtiKey)
        if !isEdit {
            U.shared.set(Date().dateToString(), C.dateKey)
            changeRootView.value = ()
        }
    }
}
