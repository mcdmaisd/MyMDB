//
//  UserInfoView.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import UIKit

final class UserInfoView: BaseView {
    private let outlineView = UIView()
    private let profileButton = UIButton()
    private let profileImageView = ProfileImageView()
    private let rightImage = UIImage(systemName: C.forward)
    private let myMovieButton = UIButton()
    
    weak var delegate: SendTouchEvent?
    
    override func configureHierarchy() {
        addView(outlineView)
        outlineView.addSubview(profileImageView)
        outlineView.addSubview(profileButton)
        outlineView.addSubview(myMovieButton)
        NotificationCenter
            .default
            .addObserver(self, selector:#selector(receiveNotification), name: NSNotification.Name(C.userInfoChanged), object: nil)
    }
    
    override func configureLayout() {
        outlineView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalTo(profileImageView.snp.height)
            make.leading.equalToSuperview().inset(10)
        }
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        myMovieButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    override func configureView() {
        outlineView.backgroundColor = .darkGray
        outlineView.layer.cornerRadius = C.cornerRadius
        
        configureUpperView()
        configureMyMovieButton()
    }
    
    private func configureUpperView() {
        profileImageView.configureImage(U.shared.get(C.profileImageKey, nil))
        configureProfileButton()
    }
    
    private func configureProfileButton() {
        let title = U.shared.get(C.nickNameKey, "")
        let subtitle = U.shared.get(C.dateKey, "")
        let container = AttributeContainer().font(.systemFont(ofSize: C.sizeXs))

        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.title = title
        config.image = rightImage
        config.titleAlignment = .leading
        config.imagePlacement = .trailing
        config.contentInsets.leading = .zero
        config.contentInsets.trailing = .zero
        config.attributedSubtitle = AttributedString(subtitle, attributes: container)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { setting in
            var title = setting
            title.foregroundColor = UIColor.customWhite
            title.font = UIFont.boldSystemFont(ofSize: C.sizeXl)
            return title
        }
        
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        profileButton.contentHorizontalAlignment = .fill
        profileButton.configuration = config
        profileButton.tintColor = .customDarkGray
    }
    
    private func configureMyMovieButton() {
        let list = U.shared.get(C.movieCountKey, [Int]())
        let title = "\(list.count)\(C.savedMovieCountSuffix)"
        let container = AttributeContainer().font(.boldSystemFont(ofSize: C.sizeXl))

        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .customWhite
        config.baseBackgroundColor = .customTheme
        config.buttonSize = .medium
        config.cornerStyle = .medium
        config.attributedTitle = AttributedString(title, attributes: container)

        myMovieButton.configuration = config
    }
    
    @objc
    private func profileButtonTapped() {
        delegate?.sheetPresent()
    }
    
    @objc
    private func receiveNotification(_ notification: NSNotification) {
        guard let result = notification.userInfo?[C.userInfoKey] as? Bool else { return }
        result ? configureUpperView() : configureMyMovieButton()
    }
}
