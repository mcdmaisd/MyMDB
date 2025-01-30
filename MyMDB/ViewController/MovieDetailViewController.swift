//
//  MovieDetailViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-29.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    private let likeButton = LikeButton()
    private let pageControl = UIPageControl()
    private let infoStackView = UIStackView()
    
    private lazy var backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout(direction: .horizontal, itemCount: 1, inset: 0))
    
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
    
    var result: Results?
    
    override func configureHierarchy() {
        addSubView(backdropCollectionView)
        addSubView(pageControl)
    }
    
    override func configureLayout() {
        backdropCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
        }
        
        pageControl.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(backdropCollectionView)
            make.bottom.equalTo(backdropCollectionView.snp.bottom)
        }
    }
    
    override func configureView() {
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = .customWhite
        pageControl.pageIndicatorTintColor = .gray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let result else { return }
        configureNavigationBar(result)
        initCollectionView()
        makeImages(result)
    }
            
    private func initCollectionView() {
        backdropCollectionView.backgroundColor = .clear
        backdropCollectionView.delegate = self
        backdropCollectionView.dataSource = self
        backdropCollectionView.isPagingEnabled = true
        backdropCollectionView.showsHorizontalScrollIndicator = false
        backdropCollectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.id)
    }
    
    private func remakeCVLayout(_ ratio: Double) {
        backdropCollectionView.snp.remakeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(backdropCollectionView.snp.width).dividedBy(ratio)
        }
    }
        
    private func makeImages(_ result: Results) {
        let request = APIRouter.image(id: result.id)
        
        APIManager.shared.requestAPI(request) { (data: Images) in
            DispatchQueue.main.async {
                let result = Array(data.backdrops.prefix(5))
                self.backdrops = result
                self.ratio = result[0].aspect_ratio
                self.pageControl.numberOfPages = result.count
            }
        }
    }
    
    private func configureNavigationBar(_ result: Results) {
        configureNavigationTitle(self, result.title)
        configureLeftBarButtonItem(self)
        configureRightBarButtonItem(self)
        
        likeButton.configureButton(result.id)
        navigationItem.rightBarButtonItem?.customView = likeButton
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        backdrops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.id, for: indexPath) as! BackdropCollectionViewCell
        
        cell.configureData(backdrops[row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
