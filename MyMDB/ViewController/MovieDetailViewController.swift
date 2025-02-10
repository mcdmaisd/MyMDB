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
    
    private var ratio: Double = 0 {
        didSet {
            remakeCVLayout(ratio)
        }
    }
    
    private var backdrops: [ImageInfo] = [] {
        didSet {
            backdropCollectionView.reloadData()
        }
    }
    
    private var data: [[Any]] = [[], []]
    
    var result: Results?
    
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
        var title = sender.titleLabel?.text ?? ""
        var line = 0
        
        if title == C.more {
            title = C.hide
        } else {
            title = C.more
            line = 3
        }
        
        sender.setTitle(title, for: .normal)
        synopsisLabel.configureData(result?.overview ?? "", line)
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
        synopsisLabel.configureData(result?.overview ?? "", 3)
        
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let result else { return }
        configureNavigationBar(result)
        initCollectionView()
        initTableView()
        configureStackView()
        makeImages(result)
    }
        
    private func configureStackView() {
        guard let result else { return }
        
        let genres = result.genre_ids?.map { AC.genreDictionary[$0] }.prefix(2).compactMap { $0 }.joined(separator: AC.comma) ?? ""
        let movieInfo = [
            result.release_date ?? "",
            String(format: "%.1f", result.vote_average ?? 0.0),
            genres
        ]
        
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
    
    private func makeImages(_ result: Results) {
        let imageRequest = APIRouter.image(id: result.id)
        let creditRequest = APIRouter.credit(id: result.id)
        let group = DispatchGroup()
        
        group.enter()
        APIManager.shared.requestAPI(imageRequest, self) { (data: ImageResponse) in
            DispatchQueue.main.async {
                let result = Array(data.backdrops.prefix(5))
                self.data[1] = data.posters
                self.backdrops = result
                self.ratio = result.first?.aspect_ratio ?? 1
                self.pageControl.numberOfPages = result.count
                group.leave()
            }
        }
        
        group.enter()
        APIManager.shared.requestAPI(creditRequest, self) { (data: CreditResponse) in
            DispatchQueue.main.async {
                self.data[0] = data.cast
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            self.tableView.isHidden = false
            self.tableView.snp.updateConstraints {
                $0.height.equalTo(self.tableView.contentSize.height)
            }
            self.scrollView.layoutIfNeeded()
        }
    }
    
    private func configureNavigationBar(_ result: Results) {
        configureNavigationTitle(self, result.title)
        configureLeftBarButtonItem(self)
        configureRightBarButtonItem(self)
        
        likeButton.configureButton(result.id)
        navigationItem.rightBarButtonItem?.customView = likeButton
    }
    
    private func configureHeaderView(_ section: Int) -> UIView {
        let header = HeaderLabel()
        let empty = data[section].isEmpty
        
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
        // collectionview 2개 만들어서 if collectionview = backdropcv {} 이렇게 나누기
        backdrops.isEmpty ? 1 : backdrops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.id, for: indexPath) as! BackdropCollectionViewCell
        
        backdrops.isEmpty ? cell.configureData() : cell.configureData(backdrops[row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scene = UIApplication.shared.getCurrentScene()
        pageControl.currentPage = Int(floor(scrollView.contentOffset.x / scene.bounds.width))
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        configureHeaderView(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: CastAndPosterTableViewCell.id, for: indexPath) as! CastAndPosterTableViewCell
        
        cell.backgroundColor = .clear
        cell.collectionView.tag = section
        cell.configureData(data[section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIApplication.shared.getCurrentScene().bounds.width / 3
    }
}
