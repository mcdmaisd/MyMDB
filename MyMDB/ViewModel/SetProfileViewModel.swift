//
//  SetProfileViewModel.swift
//  MyMDB
//
//  Created by ilim on 2025-02-08.
//

import Foundation

class SetProfileViewModel: BaseViewModel, SendNotification {
    var input: Input
    var output: Output
    
    struct Input {
        let profileImage = Observable(U.shared.get(C.profileImageKey, C.randomProfileImage))
        let nickname = Observable(U.shared.get(C.nickNameKey, ""))
        let date = Observable(())
        let selectedMbti: Observable<Int?> = .init(nil)
    }
    
    struct Output {
        let profileImage = Observable("")
        let nickname = Observable("")
        let nicknameValidationMessage = Observable("")
        let collectionViewReload = Observable(())
        let changeRootView = Observable(())
        let saveButton: Observable<Bool> = .init(false)
    }
        
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
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.profileImage.bind { [weak self] name in
            self?.output.profileImage.value = name
        }
        
        input.nickname.bind { [weak self] nickname in
            self?.checkNickname(nickname)
        }
        
        input.selectedMbti.bind { [weak self] index in
            guard let index else { return }
            self?.toggleKey(index)
        }
        
        input.date.lazyBind { [weak self] _ in
            self?.save()
        }
    }
    
    func postNotification(_ name: String, _ value: Bool, _ id: Int?) {
        NotificationCenter.default.post(
            name: NSNotification.Name(name), object: id, userInfo: [C.userInfoKey: value]
        )
    }
    
    private func toggleKey(_ index: Int) {
        guard let index = input.selectedMbti.value else { return }
        let pairIndex = index < 4 ? index + 4 : index - 4
        mbti[index].toggle()
        mbti[pairIndex] = false
        checkMbti()
        output.collectionViewReload.value = ()
    }
    
    private func checkNickname(_ nickname: String) {
        let text = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        output.nickname.value = text
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
        output.nicknameValidationMessage.value = errorMessage.compactMap { $0 }.joined(separator: C.newline)
        isValidNickname = result
        configureSaveButtonStatus()
    }
    
    private func checkMbti() {
        isValidMbti = mbti.filter { $0 == true }.count == 4
        configureSaveButtonStatus()
    }
    
    private func configureSaveButtonStatus() {
        output.saveButton.value = isValidNickname && isValidMbti
    }
    
    private func save() {
        U.shared.set(output.profileImage.value, C.profileImageKey)
        U.shared.set(output.nickname.value, C.nickNameKey)
        U.shared.set(mbti, C.mbtiKey)
        if !isEdit {
            U.shared.set(Date().dateToString(), C.dateKey)
            output.changeRootView.value = ()
        }
        postNotification(C.userInfoChanged ,true, nil)
    }
}
