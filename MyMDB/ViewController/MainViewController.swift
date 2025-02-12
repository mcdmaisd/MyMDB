//
//  MainViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

final class MainViewController: BaseViewController {
    private let viewModel = MainViewModel()
    private let infoView = UserInfoView()
    private let recentSearches = HeaderLabel()
    private let removeAllButton = LabelButton(title: C.removeAll)
    private let emptyHistory = CustomLabel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let todayMovie = HeaderLabel()
    
    private lazy var flowlayout = flowLayout(direction: .horizontal, itemCount: 1, inset: 10)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
    
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
        initCollectionView()
        binding()
    }
    
    private func binding() {
        viewModel.output.searchHistory.bind { [weak self] history in
            guard let self else { return }
            removeSubviews()
            hideView(history.isEmpty)
            configureStackView(history)
        }
        
        viewModel.output.movies.bind { [weak self] movies in
            self?.collectionView.reloadData()
        }
        
        viewModel.output.index.lazyBind { [weak self] index in
            guard let index else { return }
            UIView.performWithoutAnimation {
                self?.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
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
    
    private func configureStackView(_ keywords: [String]) {
        if keywords.isEmpty { return }
        
        for (i, keyword) in keywords.enumerated() {
            stackView.addArrangedSubview(configureButton(i, keyword))
        }
        
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    private func configureButton(_ tag: Int, _ keyword: String) -> KeywordButton {
        let button = KeywordButton(keyword, tag)
        button.addTarget(self, action: #selector(keywordButtonTapped), for: .touchUpInside)
        
        if let image = button.imageView {
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(configureTapGestureRecognizer())
        }
        
        return button
    }
    
    private func configureTapGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(removeKeyword))
    }
    
    private func removeSubviews() {
        let subviews = stackView.arrangedSubviews
        
        subviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
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
        viewModel.input.removeAllButton.value = ()
    }
    
    @objc
    private func removeKeyword(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.superview?.tag else { return }
        viewModel.input.removeButton.value = tag
    }
    
    @objc
    private func keywordButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        
        viewModel.input.keywordIndex.value = tag
        moveToSearch(sender.titleLabel?.text)
    }
        
    private func moveToSearch(_ title: String? = nil) {
        let vc = SearchViewController()

        vc.viewModel.input.title.value = title
        vc.viewModel.keyword = { [weak self] data in
            self?.viewModel.input.keyword.value = data
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func rightBarButtonTapped() {
        moveToSearch()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.output.movieCount.value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as! TodayMovieCollectionViewCell
        
        viewModel.output.movies.bind { movies in
            cell.configureData(movies[row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.output.movies.bind { [weak self] movies in
            guard let self else { return }
            moveToDetailVC(self, movies[indexPath.row])
        }
    }
}
