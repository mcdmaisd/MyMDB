//
//  PosterCollectionViewCell.swift
//  MyMDB
//
//  Created by ilim on 2025-01-26.
//

import UIKit

final class PosterCollectionViewCell: BaseCollectionViewCell {
    private let posterImage = PosterView()

    static let id = getId()
    
    override func configureHierarchy() {
        addSubView(posterImage)
    }
    
    override func configureLayout() {
        posterImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        posterImage.layer.cornerRadius = .zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.configureImageView()
    }
    
    func configureData(_ name: String) {
        posterImage.configureImageView(name, true)
    }
}
