//
//  ProfileImageView.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import UIKit

final class ProfileImageView: BaseView {
    private let profileImageView = UIImageView()

    override func configureHierarchy() {
        addView(profileImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        profileImageView.contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.borderWidth = C.selectedBorderWidth
        layer.borderColor = UIColor.customTheme.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    private func configureImageByUrl(_ name: String) {
        layer.borderColor = nil
        layer.borderWidth = .zero
        
        let url = URL(string: "\(AC.baseImageURL)\(name)")
        
        profileImageView.kf.setImage(with: url)
    }
    
    func configureImage(_ name: String = "") {
        let imageName = name.isEmpty ? C.tabbarImages[2] : name
        
        if imageName.contains(C.slash) {
            configureImageByUrl(imageName)
            return
        } else if imageName.contains("_") {
            profileImageView.image = UIImage(named: imageName)
        } else {
            profileImageView.image = UIImage(systemName: imageName)
        }
    }
}
