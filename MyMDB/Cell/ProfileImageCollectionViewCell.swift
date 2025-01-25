//
//  ProfileImageCollectionViewCell.swift
//  MyMDB
//
//  Created by ilim on 2025-01-26.
//

import UIKit

class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    
    private let profileImageView = UIImageView()
    
    static let id = getId()
    
    override func configureHierarchy() {
        addSubView(profileImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .clear
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.customLightGray.cgColor
        profileImageView.layer.borderWidth = C.unselectedBorderWidth
        profileImageView.alpha = C.unselectedAlpha
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        profileImageView.layer.borderColor = UIColor.customLightGray.cgColor
        profileImageView.layer.borderWidth = C.unselectedBorderWidth
        profileImageView.alpha = C.unselectedAlpha
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    func configureData(_ tag: Int, _ selected: Int) {
        profileImageView.image = UIImage(named: "\(C.profileImagePrefix)\(tag)")

        if tag == selected {
            profileImageView.layer.borderColor = UIColor.customTheme.cgColor
            profileImageView.layer.borderWidth = C.selectedBorderWidth
            profileImageView.alpha = C.selectedAlpha
        }
    }
}
