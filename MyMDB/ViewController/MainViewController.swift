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
    
    private lazy var flowlayout = flowLayout(direction: .horizontal, itemCount: 1, inset: 10)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
    
    private var keywords = U.shared.get(C.searchHistoryKey, [String]()) {
        didSet {
            hideView(keywords.isEmpty)
            U.shared.set(keywords, C.searchHistoryKey)
            removeSubviews()
            if !keywords.isEmpty { configureStackView() }
        }
    }
    
    private var movies: [TMDBMovieInfo] = [] {
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
        infoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(infoView.snp.width).multipliedBy(0.3)
        }
        
        recentSearches.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(5)
            make.leading.equalTo(infoView)
        }
        
        removeAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearches)
            make.trailing.equalTo(infoView)
        }
        
        emptyHistory.snp.makeConstraints { make in
            make.top.equalTo(recentSearches.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(recentSearches.snp.bottom).offset(5)
            make.leading.equalTo(recentSearches)
            make.trailing.equalToSuperview()
            make.height.equalTo(scrollView.contentLayoutGuide.snp.height)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        todayMovie.snp.makeConstraints { make in
            make.top.equalTo(emptyHistory.snp.bottom).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(todayMovie.snp.bottom)
            make.leading.equalToSuperview()
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        infoView.delegate = self
        
        recentSearches.configureData(C.recentSearches)
        
        hideView(keywords.isEmpty)
        
        removeAllButton.addTarget(self, action: #selector(removeAllButtonTapped), for: .touchUpInside)
        
        emptyHistory.configureLabel(C.emptyHistory)
        
        scrollView.showsHorizontalScrollIndicator = false
        
        stackView.spacing = C.stackViewSpacing
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        
        todayMovie.configureData(C.todayMovie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationTitle(self, C.main)
        configureRightBarButtonItem(self, nil, C.searchImage)
        configureStackView()
        initCollectionView()
        configureCollectionView()
        NotificationCenter
            .default
            .addObserver(self, selector:#selector(reloadButton), name: .name, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        remakeFlowlayout(collectionView, widthRatio: 0.6)
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
        let button = KeywordButton(keyword, tag)
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
        APIManager.shared.requestAPI(APIRouter.trending, self) { (data: TMDBSearchAndTrendingResponse) in
            self.movies = data.results
        }
    }
    
    private func initCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
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
        let word = keywords[tag]
    
        moveToSearch(word)
        if tag == 0 { return }
        insertWord(word)
    }
    
    @objc
    private func reloadButton(_ notification: Notification) {
        if let data = notification.object as? Int {
            for (i, movie) in movies.enumerated() {
                if movie.id == data {
                    UIView.performWithoutAnimation {
                        collectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
                    }
                    break
                }
            }
        }
    }
    
    private func insertWord(_ word: String) {
        if let index = keywords.firstIndex(of: word) {
            keywords.remove(at: index)
        }
        keywords.insert(word, at: 0)
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    private func moveToSearch(_ title: String? = nil) {
        let vc = SearchViewController()

        vc.movieTitle = title
        vc.keyword = { [self] data in
            let result = keywords.filter { $0.localizedCaseInsensitiveCompare(data) == .orderedSame }
            result.isEmpty ? insertWord(data) : insertWord(result.first!)
        }
                
        if let title {
            let request = APIRouter.search(keyword: title, page: AC.firstPage)
            
            APIManager.shared.requestAPI(request, self) { (data: TMDBSearchAndTrendingResponse) in
                vc.totalPage = data.total_pages
                vc.searchResults = data.results
            }
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
        
        cell.configureData(movies[row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveToDetailVC(self, movies[indexPath.row])
    }
}
