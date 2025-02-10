//
//  ProfileContainerViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-26.
//

import UIKit

final class ProfileContainerView: BaseView {
    private let profileImageView = ProfileImageView()
    private let imageOutlineView = UIView()
    private let cameraBadgeImageView = UIImageView()
    
    private var profileImageName: String?
    
    init(name: String = "") {
        profileImageName = name
        profileImageView.configureImage(name)
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addView(profileImageView)
        addView(imageOutlineView)
        imageOutlineView.addSubview(cameraBadgeImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageOutlineView.snp.makeConstraints { make in
            make.width.equalTo(profileImageView.snp.width).dividedBy(3)
            make.height.equalTo(imageOutlineView.snp.width)
            make.trailing.bottom.equalTo(profileImageView)
        }
        
        cameraBadgeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    override func configureView() {
        imageOutlineView.clipsToBounds = true
        imageOutlineView.backgroundColor = .customTheme
        imageOutlineView.tintColor = .customWhite
        
        cameraBadgeImageView.contentMode = .scaleAspectFill
        cameraBadgeImageView.image = UIImage(systemName: C.camera)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageOutlineView.layer.cornerRadius = imageOutlineView.frame.width / 2
    }
    
    func configureData(_ name: String) {
        profileImageName = name
        profileImageView.configureImage(profileImageName ?? C.randomProfileImage)
    }
    
    func getImageName() -> String {
        profileImageName ?? ""
    }
}
