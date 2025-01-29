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
    private let likeButton = LikeButton()
    private let mainStackView = UIStackView()
    private let stackView = UIStackView()
        
    override func configureHierarchy() {
        addSubView(posterView)
        addSubView(titleLabel)
        addSubView(dateLabel)
        addSubView(likeButton)
        //addSubView(mainStackView)
        addSubView(stackView)
    }
    
    override func configureLayout() {
        posterView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(20)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalTo(posterView.snp.width).multipliedBy(1.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterView)
            make.leading.equalTo(posterView.snp.trailing).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(5)
            make.size.equalTo(dateLabel.snp.height)
            make.bottom.equalTo(posterView)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(posterView)
        }
    }
    
    override func configureView() {
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        dateLabel.setContentHuggingPriority(.required, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterView.configureImageView()
        titleLabel.configureLabel()
        dateLabel.configureLabel()
        likeButton.configureButton()
        removeSubviews()
    }
        
    private func removeSubviews() {
        let subviews = stackView.arrangedSubviews
        
        subviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    private func configureSubStackView() -> UIStackView {
        let subStackView = UIStackView()
        
        subStackView.axis = .horizontal
        subStackView.spacing = 5
        subStackView.distribution = .fillProportionally
        
        return subStackView
    }
    
    private func configureGenreView(_ genres: [Int]) {
        //var genreViews: [GenreView] = []

        for genre in genres {
            let genre = AC.genreDictionary[genre] ?? ""
            let genreView = GenreView()
            
            genreView.configureLabel(genre)
            stackView.addArrangedSubview(genreView)
        }
        
        //configureStackView(genreViews)
    }
    
    private func configureStackView(_ views: [GenreView]) {
        var index = 0
        
        for view in views {
            
        }
    }
    
    func configureData(_ data: Results) {
        posterView.configureImageView(data.poster_path ?? "")
        titleLabel.configureLabel(data.title, 2)
        dateLabel.configureLabel(data.release_date?.replacingOccurrences(of: "-", with: ". ") ?? "")
        likeButton.configureButton(data.id)
        configureGenreView(data.genre_ids ?? [])
    }
}
