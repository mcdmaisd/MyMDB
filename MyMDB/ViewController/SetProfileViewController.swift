//
//  SetProfileViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

class SetProfileViewController: BaseViewController {
    
    private let profileImageView = UIImageView()
    private let outlineView = UIView()
    private let cameraBadgeImageView = UIImageView()
    private let nicknameTextField = UITextField()
    private let underlineView = UIView()
    private let statusLabel = UILabel()
    private let registerButton = CustomButton(title: C.completion)
    private let isEdit = U.shared.get(C.firstKey) as? Bool ?? false

    private var profileImageName = U.shared.get(C.profileImageKey) as? String ?? C.randomProfileImage

    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    
    override func configureHierarchy() {
        addSubView(profileImageView)
        addSubView(outlineView)
        outlineView.addSubview(cameraBadgeImageView)
        addSubView(nicknameTextField)
        addSubView(underlineView)
        addSubView(statusLabel)
        addSubView(registerButton)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).dividedBy(4)
            make.height.equalTo(profileImageView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        outlineView.snp.makeConstraints { make in
            make.width.equalTo(profileImageView.snp.width).dividedBy(3)
            make.height.equalTo(outlineView.snp.width)
            make.trailing.bottom.equalTo(profileImageView)
        }
        
        cameraBadgeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
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
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(nicknameTextField)
        }
    }
    
    override func configureView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = C.selectedBorderWidth
        profileImageView.layer.borderColor = UIColor.customTheme.cgColor
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        outlineView.clipsToBounds = true
        outlineView.backgroundColor = .customTheme
        outlineView.tintColor = .customWhite
        
        cameraBadgeImageView.contentMode = .scaleAspectFill
        cameraBadgeImageView.image = UIImage(systemName: C.camera)
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        outlineView.layer.cornerRadius = outlineView.frame.width / 2
    }
    
    override func rightBarButtonTapped() {
        save()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let title = isEdit ? C.editProfileTitle : C.setProfileTitle
        
        configureNavigationBar(self, title)
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
        let nickName = U.shared.get(C.nickNameKey) as? String ?? ""
        
        profileImageView.image = UIImage(named: profileImageName)
        nicknameTextField.text = nickName
    }
    
    @objc
    private func verifyNickname(_ sender: UITextField) {
        guard let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        nicknameTextField.text = text
        if text.isEmpty {
            statusLabel.text?.removeAll()
            return
        }
        
        let hasInvalidLength = text.count < 2 || text.count >= 10
        let hasInvalidCharacter = !text.filter(C.invalidCharacterSet.contains).isEmpty
        let hasNumber = !text.filter { $0.isNumber }.isEmpty
        let result = !hasInvalidLength && !hasInvalidCharacter && !hasNumber
        
        if isEdit {
            navigationItem.rightBarButtonItem?.isHidden = !result
        } else {
            registerButton.isHidden = !result
        }
        
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
        
        statusLabel.text = errorMessage.compactMap { $0 }.joined(separator: C.newline)
    }
    
    private func save() {
        U.shared.set(profileImageName, C.profileImageKey)
        U.shared.set(nicknameTextField.text ?? "", C.nickNameKey)
    }
    
    @objc
    private func registerButtonTapped() {
        save()
        changeRootView()
    }
    
    @objc
    private func imageTapped() {
        let vc = SetProfileImageViewController()
        
        vc.image = profileImageName
        
        vc.contents = { data in
            self.profileImageName = data
            self.profileImageView.image = UIImage(named: data)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

