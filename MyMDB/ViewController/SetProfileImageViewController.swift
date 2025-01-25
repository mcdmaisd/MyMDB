//
//  SetProfileImageViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

final class SetProfileImageViewController: BaseViewController {

    var image: String?
    var contents: ((String) -> Void)?

    private let profileImageView = UIImageView()
    private let outlineView = UIView()
    private let cameraBadgeImageView = UIImageView()
    
    private lazy var selectedIndex = Int(image?.filter { $0.isNumber } ?? "") ?? 0
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout(4))
    
    override func configureHierarchy() {
        addSubView(profileImageView)
        addSubView(outlineView)
        outlineView.addSubview(cameraBadgeImageView)
        addSubView(collectionView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).dividedBy(4)
            make.height.equalTo(profileImageView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        outlineView.snp.makeConstraints { make in
            make.width.equalTo(profileImageView.snp.width).dividedBy(3)
            make.height.equalTo(outlineView.snp.width)
            make.trailing.bottom.equalTo(profileImageView)
        }
        
        cameraBadgeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = C.selectedBorderWidth
        profileImageView.layer.borderColor = UIColor.customTheme.cgColor
        
        outlineView.clipsToBounds = true
        outlineView.backgroundColor = .customTheme
        outlineView.tintColor = .customWhite
        
        cameraBadgeImageView.contentMode = .scaleAspectFill
        cameraBadgeImageView.image = UIImage(systemName: C.camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.image = UIImage(named: makeImageName())
        configureNavigationBar(self, C.setProfileImageTitle)
        initCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        outlineView.layer.cornerRadius = outlineView.frame.width / 2
    }

    private func initCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
    }
    
    private func makeImageName() -> String {
        "\(C.profileImagePrefix)\(selectedIndex)"
    }
    
    @objc
    override func back() {
        super.back()
        contents?(makeImageName())
    }
}

extension SetProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        C.profileImageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as! ProfileImageCollectionViewCell
        
        cell.configureData(tag, selectedIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let row = indexPath.row
        if selectedIndex == row { return }
        selectedIndex = row
        profileImageView.image = UIImage(named: makeImageName())
        collectionView.reloadData()
    }
}
