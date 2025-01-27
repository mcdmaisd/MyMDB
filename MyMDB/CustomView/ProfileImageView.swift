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
    
    func configureImage(_ name: String?) {
        guard let name else { return }
        profileImageView.image = UIImage(named: name)
    }
    
    func configureImageByUrl(_ name: String) {
        layer.borderColor = nil
        layer.borderWidth = .zero
        
        let url = URL(string: name)
        
        profileImageView.kf.setImage(with: url)
    }
}
