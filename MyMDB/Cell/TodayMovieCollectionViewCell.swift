//
//  TodayMovieCollectionViewCell.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import UIKit

final class TodayMovieCollectionViewCell: BaseCollectionViewCell {
    private let posterImageView = PosterView()
    private let titleLabel = HeaderLabel()
    private let likeButton = LikeButton()
    private let overviewLabel = OverViewLabel()
    
    static let id = getId()
    
    override func configureHierarchy() {
        addSubView(overviewLabel)
        addSubView(titleLabel)
        addSubView(likeButton)
        addSubView(posterImageView)
    }
    
    override func configureLayout() {
        overviewLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(overviewLabel.snp.top)
        }
        
        likeButton.snp.makeConstraints { make in
            make.height.equalTo(titleLabel)
            make.width.equalTo(likeButton.snp.height)
            make.bottom.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(likeButton.snp.top)
        }
    }
    
    override func configureView() {
        posterImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        likeButton.setContentHuggingPriority(.required, for: .horizontal)
        likeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        overviewLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.configureImageView()
        titleLabel.configureLabel()
        likeButton.configureButton()
        overviewLabel.configureLabel()
    }
    
    func configureData(_ data: Results) {
        posterImageView.configureImageView(data.poster_path ?? "")
        titleLabel.configureLabel(data.title)
        likeButton.configureButton(data.id)
        overviewLabel.configureLabel(data.overview, 2)
    }
}
