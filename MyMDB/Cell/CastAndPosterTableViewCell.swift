//
//  CastAndPosterTableViewCell.swift
//  MyMDB
//
//  Created by ilim on 2025-01-26.
//

import UIKit

final class CastAndPosterTableViewCell: BaseTableViewCell {
    private let inset: CGFloat = 10
    static let id = getId()
    
    private lazy var flowlayout = flowLayout(direction: .horizontal, itemCount: 1, inset: self.inset)
    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
    
    private var results: [Any] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func configureHierarchy() {
        addSubView(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        initCollectionView()
    }
    
    private func initCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.id)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.id)
    }
    
    func configureData(_ data: [Any]) {
        results = data
    }
}

extension CastAndPosterTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let tag = collectionView.tag
        let item = results[row]
        let cellType = CellType(rawValue: tag) ?? .cast
        let id = cellType.id
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        
        switch cellType {
        case .cast:
            let data = item as! TMDBCastInfo
            (cell as! CastCollectionViewCell).configureData(data)
        case .poster:
            let data = item as! TMDBImageInfo
            (cell as! PosterCollectionViewCell).configureData(data.file_path)
        }
        
        return cell
    }
}

extension CastAndPosterTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = indexPath.row
        let poster = results[row] as? TMDBImageInfo
        let tag = collectionView.tag
        let cellType = CellType(rawValue: tag) ?? .cast

        switch cellType {
        case .cast:
            return CGSize(
                width: (collectionView.bounds.width - inset) / 2,
                height: (collectionView.bounds.height - inset) / 2
            )
        case .poster:
            let height = collectionView.bounds.height
            let itemWidth = height * (poster?.aspect_ratio ?? 0)
            let itemHeight = height
            
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
}
