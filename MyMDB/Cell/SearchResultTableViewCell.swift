//
//  SearchResultTableViewCell.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import UIKit

final class SearchResultTableViewCell: BaseTableViewCell {
    static let id = getId()
    
    private let posterView = PosterView()
    private let titleLabel = HeaderLabel()
    private let dateLabel = CustomLabel()
    private let overviewLabel = OverViewLabel()
    private let likeButton = LikeButton()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    override func configureHierarchy() {
        addSubView(posterView)
        addSubView(titleLabel)
        addSubView(dateLabel)
        addSubView(overviewLabel)
        addSubView(likeButton)
        addSubView(scrollView)
        scrollView.addSubview(stackView)
    }
    
    override func configureLayout() {
        posterView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(20).priority(.high)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalTo(posterView.snp.width).multipliedBy(1.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterView)
            make.leading.equalTo(posterView.snp.trailing).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(likeButton)
            make.bottom.lessThanOrEqualTo(likeButton.snp.top).offset(-5)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(posterView.snp.height).dividedBy(4)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(likeButton.snp.leading).offset(-5)
            make.bottom.equalTo(posterView)
            make.height.equalTo(scrollView.contentLayoutGuide.snp.height)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }
    }
    
    override func configureView() {
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        dateLabel.setContentHuggingPriority(.required, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        scrollView.showsHorizontalScrollIndicator = false
        
        overviewLabel.setContentHuggingPriority(.required, for: .vertical)
        overviewLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        likeButton.setContentHuggingPriority(.required, for: .vertical)
        likeButton.setContentCompressionResistancePriority(.required, for: .vertical)
        
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterView.configureImageView()
        titleLabel.configureLabel()
        dateLabel.configureLabel()
        overviewLabel.configureLabel()
        likeButton.configureButton()
        removeSubviews()
    }
    
    private func remakeLayout(_ empty: Bool) {
        likeButton.snp.remakeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(5)
            make.size.equalTo(posterView.snp.height).dividedBy(4)
            if empty {
                make.bottom.equalTo(posterView)
            } else {
                make.centerY.equalTo(scrollView)
            }
        }
    }
            
    private func removeSubviews() {
        let subviews = stackView.arrangedSubviews
        
        subviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    private func configureGenreView(_ genres: [Int]) {
        remakeLayout(genres.isEmpty)
        var genreViews: [GenreView] = []
        
        for genre in genres {
            let genre = AC.genreDictionary[genre] ?? ""
            let genreView = GenreView()
            
            genreView.configureLabel(genre)
            genreViews.append(genreView)
        }
        
        configureStackView(genreViews)
    }
    
    private func configureStackView(_ views: [GenreView]) {
        for view in views {
            stackView.addArrangedSubview(view)
        }
    }
    
    func configureData(_ data: Results) {
        posterView.configureImageView(data.poster_path ?? "")
        titleLabel.configureLabel(data.title, 2)
        dateLabel.configureLabel(data.release_date?.replacingOccurrences(of: AC.dash, with: AC.period) ?? "")
        overviewLabel.configureLabel(data.overview, 3)
        likeButton.configureButton(data.id)
        configureGenreView(data.genre_ids ?? [])
    }
}
