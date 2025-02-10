//
//  SetProfileImageViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

final class SetProfileImageViewController: BaseViewController {
    var viewModel = SetProfileImageViewModel()
    
    private let profileView = ProfileContainerView()
    private lazy var flowlayout = flowLayout(direction: .vertical, itemCount: 4, inset: 5)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
    
    override func configureHierarchy() {
        addSubView(profileView)
        addSubView(collectionView)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).dividedBy(4)
            make.height.equalTo(profileView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = viewModel.isEdit ? C.editProfileImgaeTitle : C.setProfileImageTitle
        configureNavigationTitle(self, title)
        configureLeftBarButtonItem(self)
        initCollectionView()
        binding()
    }
    
    private func binding() {
        viewModel.output.selectedImage.bind { [weak self] name in
            self?.profileView.configureData(name)
        }
        
        viewModel.output.collectionViewReload.lazyBind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    private func initCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
    }
        
    @objc
    override func back() {
        super.back()
    }
}

extension SetProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        C.profileImageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as! ProfileImageCollectionViewCell
        
        cell.configureData(tag, viewModel.selectedIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let row = indexPath.row
        viewModel.input.imageIndex.value = row
    }
}
