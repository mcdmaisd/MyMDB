//
//  CastCollectionViewCell.swift
//  MyMDB
//
//  Created by ilim on 2025-01-26.
//

import UIKit

final class CastCollectionViewCell: BaseCollectionViewCell {
    private let profileImage = ProfileImageView()
    private let nameLabel = HeaderLabel()
    private let characterLabel = CustomLabel()
    
    static let id = getId()
    
    override func configureHierarchy() {
        addSubView(profileImage)
        addSubView(nameLabel)
        addSubView(characterLabel)
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(profileImage.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.top.trailing.equalToSuperview().inset(5)
        }
        
        characterLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.trailing.equalTo(nameLabel)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .clear
        profileImage.layer.borderWidth = .zero
        nameLabel.adjustsFontSizeToFitWidth = true
        characterLabel.numberOfLines = 2
        characterLabel.font = .systemFont(ofSize: C.sizeXs)
        characterLabel.textAlignment = .left
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.layer.borderWidth = .zero
        profileImage.configureImage()
        nameLabel.configureLabel()
        characterLabel.configureLabel()
    }
    
    func configureData(_ data: CastInfo) {
        profileImage.configureImage(data.profile_path ?? "")
        nameLabel.configureLabel(data.original_name ?? "")
        characterLabel.configureLabel(data.character ?? "")
    }
}
