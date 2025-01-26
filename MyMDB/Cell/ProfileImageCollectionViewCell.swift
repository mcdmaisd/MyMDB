//
//  ProfileImageCollectionViewCell.swift
//  MyMDB
//
//  Created by ilim on 2025-01-26.
//

import UIKit

class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    private let profileImageView = ProfileImageView()
    
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
        setUnselectedCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setUnselectedCell()
    }
    
    private func setUnselectedCell() {
        profileImageView.layer.borderColor = UIColor.customLightGray.cgColor
        profileImageView.layer.borderWidth = C.unselectedBorderWidth
        profileImageView.alpha = C.unselectedAlpha
    }
        
    func configureData(_ tag: Int, _ selected: Int) {
        profileImageView.configureImage("\(C.profileImagePrefix)\(tag)")

        if tag == selected {
            profileImageView.layer.borderColor = UIColor.customTheme.cgColor
            profileImageView.layer.borderWidth = C.selectedBorderWidth
            profileImageView.alpha = C.selectedAlpha
        }
    }
}
