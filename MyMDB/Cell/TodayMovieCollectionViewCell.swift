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
    private let overviewLabel = UILabel()
    
    static let id = getId()
    
    override func configureHierarchy() {
        addSubView(posterImageView)
        addSubView(titleLabel)
        addSubView(likeButton)
        addSubView(overviewLabel)
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {//poster compression priority를 제일 낮게 주고 나머지는 required로
        overviewLabel.numberOfLines = 2
    }
    
    func configureData(_ data: Results) {
        posterImageView.configureImageView(data.poster_path)
        titleLabel.text = data.title
        likeButton.configureButton(data.id)
        overviewLabel.text = data.overview
    }
}
