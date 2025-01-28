//
//  MainViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

final class MainViewController: BaseViewController {
    private let infoView = UserInfoView()
    private let recentSearches = HeaderLabel()
    private let removeAllButton = LabelButton(title: C.removeAll)
    private let emptyHistory = CustomLabel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let todayMovie = HeaderLabel()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout(2))
    
    private var keywords = U.shared.get(C.searchHistoryKey, [String]()) {
        didSet {
            hideView(keywords.isEmpty)
            U.shared.set(keywords, C.searchHistoryKey)
            removeSubviews()
            if !keywords.isEmpty { configureStackView() }
        }
    }
    
    private var movies: [Results] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func configureHierarchy() {
        addSubView(infoView)
        addSubView(recentSearches)
        addSubView(removeAllButton)
        addSubView(emptyHistory)
        addSubView(scrollView)
        scrollView.addSubview(stackView)
        addSubView(todayMovie)
        addSubView(collectionView)
    }
    
    override func configureLayout() {
        infoView.setInfoConstraint(self)
        
        recentSearches.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(10)
            make.leading.equalTo(infoView)
        }
        
        removeAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearches)
            make.trailing.equalTo(infoView)
        }
        
        emptyHistory.snp.makeConstraints { make in
            make.top.equalTo(recentSearches.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(recentSearches.snp.bottom).offset(10)
            make.leading.equalTo(recentSearches)
            make.trailing.equalToSuperview()
            make.height.equalTo(scrollView.contentLayoutGuide.snp.height)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        todayMovie.snp.makeConstraints { make in
            make.top.equalTo(emptyHistory.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(todayMovie.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureView() {
        infoView.delegate = self
        
        recentSearches.configureLabel(C.recentSearches)
        
        hideView(keywords.isEmpty)
        
        removeAllButton.addTarget(self, action: #selector(removeAllButtonTapped), for: .touchUpInside)
        
        emptyHistory.configureLabel(C.emptyHistory)
        emptyHistory.sizeToFit()
        
        scrollView.showsHorizontalScrollIndicator = false
        
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        
        todayMovie.configureLabel(C.todayMovie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(self, C.main)
        configureRightBarButtonItem(self, nil, C.searchImage)
        configureStackView()
    }
    
    private func hideView(_ empty: Bool) {
        removeAllButton.isHidden = empty
        scrollView.isHidden = empty
        emptyHistory.isHidden = !empty
    }
    
    private func configureStackView() {
        for (i, keyword) in keywords.enumerated() {
            stackView.addArrangedSubview(configureButton(i, keyword))
        }
    }
    
    private func configureButton(_ tag: Int, _ keyword: String) -> KeywordButton {
        let button = KeywordButton()
        button.configureButton(keyword, tag)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        if let image = button.imageView {
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(configureTapGestureRecognizer())
        }

        return button
    }
    
    private func configureTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeKeyword))
        
        return tapGesture
    }
    
    private func removeSubviews() {
        let subviews = stackView.arrangedSubviews
    
        subviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    private func configureCollectionView() {
        let request = APIRouter.trending()
        
        APIManager.shared.requestAPI(request) { (data: Trending) in
            self.movies = data.results
            self.initCollectionView()
        }
    }
    
    private func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.id)
    }
    
    @objc
    private func removeAllButtonTapped() {
        keywords.removeAll()
    }
    
    @objc
    private func removeKeyword(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.superview?.tag else { return }
        keywords.remove(at: tag)
    }
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        let tag = sender.tag
        moveToSearch(keywords[tag])
    }
    
    private func moveToSearch(_ title: String? = nil) {
        let vc = SearchViewController()
        
        vc.movieTitle = title
        vc.keyword = { [self] data in
            if keywords.contains(data) {
                keywords.remove(at: keywords.firstIndex(of: data) ?? 0)
            }
            
            keywords.insert(data, at: 0)
            scrollView.setContentOffset(.zero, animated: true)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

    override func rightBarButtonTapped() {
        moveToSearch()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as! TodayMovieCollectionViewCell
        
        cell.
        
        return cell
    }
    
    
}
