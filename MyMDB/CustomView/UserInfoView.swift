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
    
    override func configureHierarchy() {
        addView(outlineView)
        outlineView.addSubview(profileImageView)
        outlineView.addSubview(profileButton)
        outlineView.addSubview(myMovieButton)
    }
    
    override func configureLayout() {
        outlineView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalTo(profileImageView.snp.height)
            make.leading.equalToSuperview().inset(20)
        }
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        myMovieButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    override func configureView() {
        outlineView.backgroundColor = .darkGray
        outlineView.layer.cornerRadius = C.cornerRadius
        
        profileImageView.configureImage(U.shared.get(C.profileImageKey) as? String ?? "")
        
        configureProfileButton()
        configureMyMovieButton()
    }
    
    private func configureProfileButton() {
        let title = U.shared.get(C.nickNameKey) as? String ?? ""
        let subtitle = U.shared.get(C.dateKey) as? String ?? ""
        
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.title = title
        config.subtitle = subtitle
        config.image = rightImage
        config.titleAlignment = .leading
        config.imagePlacement = .trailing
        config.contentInsets.leading = .zero
        config.contentInsets.trailing = .zero
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { setting in
            var title = setting
            title.foregroundColor = UIColor.customWhite
            title.font = UIFont.boldSystemFont(ofSize: C.sizeXl)
            return title
        }
               
        profileButton.contentHorizontalAlignment = .fill
        profileButton.configuration = config
        profileButton.tintColor = .customDarkGray
    }
    
    private func configureMyMovieButton() {
        let count = U.shared.get(C.movieCountKey) as? Int ?? 0
        let title = "\(count)\(C.savedMovieCountSuffix)"
        let container = AttributeContainer().font(.boldSystemFont(ofSize: C.sizeXl))

        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .customWhite
        config.baseBackgroundColor = .customTheme
        config.buttonSize = .medium
        config.cornerStyle = .medium
        config.attributedTitle = AttributedString(title, attributes: container)

        myMovieButton.configuration = config
    }
}
