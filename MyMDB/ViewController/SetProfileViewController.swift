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
    private let mbtiHeader = HeaderLabel()
    private let profileView = ProfileContainerView()
    
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
        profileView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).dividedBy(4)
            make.height.equalTo(profileView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
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
        viewModel.input.date.value = ()
        dismissVC()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let title = viewModel.isEdit ? C.editProfileTitle : C.setProfileTitle
        
        configureNavigationTitle(self, title)
        configureLeftBarButtonItem(self)
        configureToolbar(nicknameTextField)
        initCollectionView()
        binding()

        if viewModel.isEdit {
            configureRightBarButtonItem(self, C.save)
            registerButton.isHidden = true
            navigationItem.leftBarButtonItem?.action = #selector(dismissVC)
            navigationItem.leftBarButtonItem?.image = UIImage(systemName: C.xmark)
        }
    }
    
    private func binding() {
        viewModel.output.profileImage.bind { [weak self] name in
            self?.profileView.configureData(name)
        }
        
        viewModel.output.nickname.bind { [weak self] nickname in
            self?.nicknameTextField.text = nickname
        }
                
        viewModel.output.nicknameValidationMessage.bind { [weak self] result in
            self?.setStatusMessage(result)
        }
        
        viewModel.output.collectionViewReload.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.output.saveButton.bind { [weak self] status in
            self?.changeButtonStatus(status)
        }
        
        viewModel.output.changeRootView.lazyBind { [weak self] _ in
            self?.changeRootView()
        }
    }
    
    private func changeButtonStatus(_ result: Bool) {
        let color: UIColor = result ? .validButton : .invalidButton
        
        if viewModel.isEdit {
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
    
    private func setStatusMessage(_ message: String) {
        statusLabel.textColor = viewModel.result ? .validNickname : .invalidNickname
        statusLabel.text = message
    }
    
    @objc
    private func verifyNickname(_ sender: UITextField) {
        viewModel.input.nickname.value = sender.text ?? ""
    }
    
    @objc
    private func registerButtonTapped() {
        viewModel.input.date.value = ()
    }
    
    @objc
    private func imageTapped() {
        let vc = SetProfileImageViewController()
        
        vc.viewModel.input.imageName.value = profileView.getImageName()
        vc.viewModel.contents = { data in
            self.viewModel.input.profileImage.value = data
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
        viewModel.input.selectedMbti.value = indexPath.row
    }
}
