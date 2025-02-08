//
//  SetProfileViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

final class SetProfileViewController: BaseViewController {
    private let nicknameTextField = UITextField()
    private let underlineView = UIView()
    private let statusLabel = UILabel()
    private let mbtiView = MBTIView()
    private let registerButton = CustomButton(title: C.completion)
    private let isEdit = U.shared.get(C.firstKey, false)
    private let imageName = U.shared.get(C.profileImageKey, C.randomProfileImage)
    
    private var hasInvalidLength = false
    private var hasInvalidCharacter = false
    private var hasNumber = false
    private var result = false

    private lazy var profileView = ProfileContainerView(name: imageName)
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    
    override func configureHierarchy() {
        addSubView(profileView)
        addSubView(nicknameTextField)
        addSubView(underlineView)
        addSubView(statusLabel)
        addSubView(mbtiView)
        addSubView(registerButton)
    }
    
    override func configureLayout() {
        profileView.setProfileConstraint(self)
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(1)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(nicknameTextField)
        }
        
        mbtiView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(underlineView)
            make.bottom.equalTo(registerButton.snp.top)
        }
        
        registerButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nicknameTextField)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(tapGestureRecognizer)
        
        nicknameTextField.font = .systemFont(ofSize: C.sizeLg)
        nicknameTextField.textColor = .customWhite
        nicknameTextField.borderStyle = .none
        nicknameTextField.addTarget(self, action: #selector(verifyNickname), for: .editingChanged)
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: C.nicknamePlaceholder, attributes: [.foregroundColor: UIColor.customDarkGray])
        
        underlineView.layer.borderColor = UIColor.customLightGray.cgColor
        underlineView.layer.borderWidth = 1
        
        statusLabel.font = .systemFont(ofSize: C.sizeLg)
        statusLabel.textColor = .customTheme
        statusLabel.numberOfLines = 0
        
        registerButton.isHidden = true
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
        
    override func rightBarButtonTapped() {
        save()
        dismissVC()
        view.postNotification(C.userInfoChanged , true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let title = isEdit ? C.editProfileTitle : C.setProfileTitle
        
        configureNavigationTitle(self, title)
        configureLeftBarButtonItem(self)
        configureToolbar(nicknameTextField)
        configureData()
        verifyNickname(nicknameTextField)

        if isEdit {
            configureRightBarButtonItem(self, C.save)
            navigationItem.leftBarButtonItem?.action = #selector(dismissVC)
            navigationItem.leftBarButtonItem?.image = UIImage(systemName: C.xmark)
        }
    }
        
    private func configureData() {
        nicknameTextField.text = U.shared.get(C.nickNameKey, nil)
    }
    
    private func hideButton() {
        if isEdit {
            navigationItem.rightBarButtonItem?.isHidden = !result
        } else {
            registerButton.isHidden = !result
        }
    }
    
    private func setStatusMessage() {
        var errorMessage: [String?] = []
        
        if hasInvalidLength {
            errorMessage.append(C.invalidLength)
        } else {
            errorMessage = [
                hasInvalidCharacter ? C.invalidCharacter : nil,
                hasNumber ? C.invalidNumber: nil,
                result ? C.validNickname: nil
            ]
        }
        
        statusLabel.textColor = result ? .customTheme : .systemPink
        statusLabel.text = errorMessage.compactMap { $0 }.joined(separator: C.newline)
    }
    
    private func save() {
        U.shared.set(profileView.getImageName(), C.profileImageKey)
        U.shared.set(nicknameTextField.text ?? "", C.nickNameKey)
        if !isEdit {
            U.shared.set(Date().dateToString(), C.dateKey)
        }
    }
    
    @objc
    private func verifyNickname(_ sender: UITextField) {
        guard let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        nicknameTextField.text = text
        if text.isEmpty {
            statusLabel.text?.removeAll()
            return
        }
        
        hasInvalidLength = text.count < 2 || text.count >= 10
        hasInvalidCharacter = !text.filter(C.invalidCharacterSet.contains).isEmpty
        hasNumber = !text.filter { $0.isNumber }.isEmpty
        result = !hasInvalidLength && !hasInvalidCharacter && !hasNumber

        hideButton()
        setStatusMessage()
    }
    
    @objc
    private func registerButtonTapped() {
        save()
        changeRootView()
    }
    
    @objc
    private func imageTapped() {
        let vc = SetProfileImageViewController()
        
        vc.image = profileView.getImageName()
        vc.contents = { data in
            self.profileView.configureData(data)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

