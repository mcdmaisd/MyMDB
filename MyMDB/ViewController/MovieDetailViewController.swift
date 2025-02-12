//
//  MovieDetailViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-29.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    private let likeButton = LikeButton()
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let infoStackView = UIStackView()
    private let synopsis = HeaderLabel()
    private let moreButton = LabelButton(title: C.more)
    private let synopsisLabel = OverViewLabel()
    private let tableView = UITableView()

    private lazy var flowlayout = flowLayout(direction: .horizontal, itemCount: 1, inset: 0)
    private lazy var backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)

    var viewModel = MovieDetailViewModel()

    override func configureHierarchy() {
        addSubView(scrollView)
        scrollView.addSubview(backdropCollectionView)
        scrollView.addSubview(pageControl)
        scrollView.addSubview(infoStackView)
        scrollView.addSubview(synopsis)
        scrollView.addSubview(moreButton)
        scrollView.addSubview(synopsisLabel)
        scrollView.addSubview(tableView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backdropCollectionView.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(0)
        }
        
        pageControl.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(backdropCollectionView)
            make.bottom.equalTo(backdropCollectionView.snp.bottom)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(backdropCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        synopsis.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(20)
            make.leading.equalTo(backdropCollectionView).inset(10)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(synopsis)
            make.trailing.equalTo(backdropCollectionView).offset(-10)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsis.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc
    private func moreButtonTapped(_ sender: UIButton) {
        let title = sender.titleLabel?.text ?? ""
        viewModel.input.moreButton.value = title
    }
    
    override func configureView() {
        scrollView.showsVerticalScrollIndicator = false
        
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = .customWhite
        pageControl.pageIndicatorTintColor = .gray
        
        infoStackView.axis = .horizontal
        infoStackView.distribution = .fillProportionally
        infoStackView.backgroundColor = .gray
        infoStackView.spacing = 1
        
        synopsis.configureData(C.synopsis)
        
        synopsisLabel.lineBreakMode = .byTruncatingTail
        
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        initTableView()
        binding()
    }
    
    private func binding() {
        viewModel.output.buttonTitle.lazyBind { [weak self] title in
            self?.moreButton.setTitle(title, for: .normal)
        }
        
        viewModel.output.numberOfLines.lazyBind { [weak self] lines in
            self?.synopsisLabel.numberOfLines = lines
        }
        
        viewModel.output.heightDivider.lazyBind { [weak self] divider in
            self?.remakeCVLayout(divider)
        }
        
        viewModel.output.backdrops.lazyBind { [weak self] _ in
            self?.backdropCollectionView.reloadData()
        }
        
        viewModel.output.movieInfo.bind { [weak self] info in
            guard let info else { return }
            self?.configureNavigationBar(info)
            self?.synopsisLabel.configureData(info.overview, 3)
        }
        
        viewModel.output.convertedInfo.lazyBind { [weak self] info in
            self?.configureStackView(info)
        }
        
        viewModel.output.pages.lazyBind { [weak self] pages in
            self?.pageControl.numberOfPages = pages
        }
        
        viewModel.output.layoutUpdate.lazyBind { [weak self] _ in
            self?.layoutUpdate()
        }
    }
        
    private func configureStackView(_ movieInfo: [String]) {
        for (i, image) in C.infoStackImages.enumerated() {
            let info = MovieInfoButton(title: movieInfo[i], image: image)
            infoStackView.addArrangedSubview(info)
        }
    }
    
    private func initCollectionView() {
        backdropCollectionView.backgroundColor = .clear
        backdropCollectionView.delegate = self
        backdropCollectionView.dataSource = self
        backdropCollectionView.isPagingEnabled = true
        backdropCollectionView.showsHorizontalScrollIndicator = false
        backdropCollectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.id)
    }
    
    private func initTableView() {
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(CastAndPosterTableViewCell.self, forCellReuseIdentifier: CastAndPosterTableViewCell.id)
    }
    
    private func remakeCVLayout(_ ratio: Double) {
        backdropCollectionView.snp.remakeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(backdropCollectionView.snp.width).dividedBy(ratio)
        }
    }
    
    private func layoutUpdate() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.isHidden = false
        tableView.snp.updateConstraints {
            $0.height.equalTo(tableView.contentSize.height)
        }
        scrollView.layoutIfNeeded()
    }
    
    private func configureNavigationBar(_ result: TMDBMovieInfo) {
        configureNavigationTitle(self, result.title)
        configureLeftBarButtonItem(self)
        configureRightBarButtonItem(self)
        
        likeButton.configureButton(result.id)
        navigationItem.rightBarButtonItem?.customView = likeButton
    }
    
    private func configureHeaderView(_ section: Int) -> UIView {
        let header = HeaderLabel()
        let empty = viewModel.castAndPoster[section].isEmpty
        
        if empty {
            header.configureData(C.emptyHeaderMessage[section])
        } else {
            header.configureData(C.sectionHeaders[section])
        }
        
        return header
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.output.backdrops.value.isEmpty ? 1 : viewModel.output.backdrops.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.id, for: indexPath) as! BackdropCollectionViewCell
        
        viewModel.output.backdrops.value.isEmpty
            ? cell.configureData()
            : cell.configureData(viewModel.output.backdrops.value[row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scene = UIApplication.shared.getCurrentScene()
        pageControl.currentPage = Int(floor(scrollView.contentOffset.x / scene.bounds.width))
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.castAndPoster.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.castAndPoster[section].count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        configureHeaderView(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: CastAndPosterTableViewCell.id, for: indexPath) as! CastAndPosterTableViewCell
        
        cell.backgroundColor = .clear
        cell.collectionView.tag = section
        cell.configureData(viewModel.castAndPoster[section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIApplication.shared.getCurrentScene().bounds.width / 3
    }
}
