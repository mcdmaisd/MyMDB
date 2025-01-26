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

    private lazy var profileView = ProfileContainerView(name: image ?? C.randomProfileImage)
    private lazy var selectedIndex = Int(image?.filter { $0.isNumber } ?? "") ?? 0
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout(4))
    
    override func configureHierarchy() {
        addSubView(profileView)
        addSubView(collectionView)
    }
    
    override func configureLayout() {
        profileView.setProfileConstraint(self)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(self, C.setProfileImageTitle)
        configureLeftBarButtonItem(self)
        initCollectionView()
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
        profileView.configureData(makeImageName())
        
        collectionView.reloadData()
    }
}
