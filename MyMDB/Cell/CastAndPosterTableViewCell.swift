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
    
    private lazy var flowlayout = flowLayout(direction: .horizontal, itemCount: 1, inset: 10)
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
        let item = results[row]
        let tag = collectionView.tag
        
        if tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as! CastCollectionViewCell
            if let cast = item as? CastInfo {
                cell.configureData(cast)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as! PosterCollectionViewCell
            if let cast = item as? ImageInfo {
                cell.configureData(cast.file_path)
            }
            return cell
        }
    }
}

extension CastAndPosterTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = indexPath.row
        let item = results[row]
        let tag = collectionView.tag

        if tag == 0 {
            return CGSize(
                width: (collectionView.bounds.width - inset) / 2,
                height: (collectionView.bounds.height - inset) / 2
            )
        } else {
            guard let poster = item as? ImageInfo else { return .zero }
            
            let height = collectionView.bounds.height
            let itemWidth = height * poster.aspect_ratio
            let itemHeight = height
            
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
}
