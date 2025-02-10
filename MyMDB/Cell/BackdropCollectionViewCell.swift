//
//  BackdropCollectionViewCell.swift
//  MyMDB
//
//  Created by ilim on 2025-01-30.
//

import UIKit

final class BackdropCollectionViewCell: BaseCollectionViewCell {
    private let imageView = PosterView()
    
    static let id = getId()
    
    override func configureHierarchy() {
        addSubView(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .clear
        imageView.layer.cornerRadius = .zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.configureImageView()
    }
        
    func configureData(_ data: TMDBImageInfo? = nil) {
        if let data {
            imageView.configureImageView(data.file_path, true)
        } else {
            imageView.configureImageView("", true)
        }
    }
}
