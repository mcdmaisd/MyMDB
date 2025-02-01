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
            make.top.bottom.equalToSuperview().inset(20)
            make.width.equalToSuperview().dividedBy(4)
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
            make.bottom.equalTo(likeButton.snp.top).offset(-5)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(safeAreaLayoutGuide.snp.width).dividedBy(10)
            make.centerY.equalTo(scrollView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(likeButton.snp.leading).offset(-5)
            make.height.equalTo(scrollView.contentLayoutGuide.snp.height)
            make.bottom.equalTo(posterView)
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
    
    private func remakeLayout() {
        likeButton.snp.remakeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(5)
            make.size.equalTo(safeAreaLayoutGuide.snp.width).dividedBy(10)
            make.bottom.equalTo(posterView)
        }
        self.layoutIfNeeded()
    }
            
    private func removeSubviews() {
        let subviews = stackView.arrangedSubviews
        
        subviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    private func configureGenreView(_ genres: [Int]) {
        if genres.isEmpty { remakeLayout() }
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
    
    func configureData(_ data: Results, _ keyword: String = "") {
        posterView.configureImageView(data.poster_path ?? "")
        titleLabel.configureLabel(data.title, 2, keyword)
        dateLabel.configureLabel(data.release_date?.replacingOccurrences(of: AC.dash, with: AC.period) ?? "")
        overviewLabel.configureLabel(data.overview, 3, keyword)
        likeButton.configureButton(data.id)
        configureGenreView(data.genre_ids ?? [])
    }
}
