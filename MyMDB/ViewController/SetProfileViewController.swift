//
//  SetProfileViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

final class SetProfileViewController: BaseViewController {
    private let viewModel = SetProfileViewModel()
    private let nicknameTextField = UITextField()
    private let underlineView = UIView()
    private let statusLabel = UILabel()
    private let registerButton = CustomButton(title: C.completion)
    private let isEdit = U.shared.get(C.firstKey, false)
    private let mbtiHeader = HeaderLabel()

    private var hasInvalidLength = false
    private var hasInvalidCharacter = false
    private var hasInvalidMBTI = false
    private var hasNumber = false
    private var result = false

    private lazy var profileView = ProfileContainerView(name: viewModel.profileImage.value)
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    private lazy var flowlayout = flowLayout(direction: .vertical, itemCount: 4, inset: 5, ratio: 0.6)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
    
    override func configureHierarchy() {
        addSubView(profileView)
        addSubView(nicknameTextField)
        addSubView(underlineView)
        addSubView(statusLabel)
        addSubView(mbtiHeader)
        addSubView(collectionView)
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
        
        mbtiHeader.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.leading.equalTo(underlineView)
            make.width.equalTo(underlineView).dividedBy(3)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mbtiHeader)
            make.leading.equalTo(mbtiHeader.snp.trailing)
            make.trailing.equalTo(underlineView)
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
        
        mbtiHeader.textAlignment = .left
        mbtiHeader.configureData(C.MBTITitle)
        
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
        initCollectionView()
        verifyNickname(nicknameTextField)
        binding()

        if isEdit {
            configureRightBarButtonItem(self, C.save)
            registerButton.isHidden = true
            navigationItem.leftBarButtonItem?.action = #selector(dismissVC)
            navigationItem.leftBarButtonItem?.image = UIImage(systemName: C.xmark)
        }
    }
    
    private func binding() {
        viewModel.profileImage.bind { [weak self] name in
            self?.profileView.configureData(name)
        }
        
        viewModel.collectionViewReload.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    private func changeButtonStatus() {
        let color: UIColor = result ? .validButton : .invalidButton
        
        if isEdit {
            navigationItem.rightBarButtonItem?.isEnabled = result
        } else {
            registerButton.configuration?.baseBackgroundColor = color
            registerButton.isUserInteractionEnabled = result
        }
    }
    
    private func initCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MbtiCollectionViewCell.self, forCellWithReuseIdentifier: MbtiCollectionViewCell.id)
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
        
        statusLabel.textColor = result ? .validNickname : .invalidNickname
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
        viewModel.nicknameInput.value = sender.text ?? ""
    }
    
    @objc
    private func registerButtonTapped() {
        save()
        changeRootView()
    }
    
    @objc
    private func imageTapped() {
        let vc = SetProfileImageViewController()
        
        vc.viewModel.image.value = profileView.getImageName()
        vc.viewModel.contents = { data in
            self.viewModel.profileImageInput.value = data
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SetProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        C.MBTIKey.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MbtiCollectionViewCell.id, for: indexPath) as! MbtiCollectionViewCell
        
        cell.configureLabel(C.MBTIKey[row], viewModel.mbti[row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.mbtiInput.value = indexPath.row
    }
}
