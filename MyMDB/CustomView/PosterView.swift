//
//  PosterView.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import UIKit

final class PosterView: BaseView {
    private let posterImageView = UIImageView()
    
    override func configureHierarchy() {
        addView(posterImageView)
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        clipsToBounds = true
        layer.cornerRadius = C.cornerRadius
        
        posterImageView.contentMode = .scaleAspectFill
    }
        
    func configureImageView(_ name: String = "", _ fit: Bool = false) {
        if name.isEmpty {
            posterImageView.image = UIImage.no
            return
        }
        
        let url = URL(string: "\(AC.baseImageURL)\(name)")
        posterImageView.kf.setImage(with: url)
        if fit { posterImageView.contentMode = .scaleAspectFit }
    }
}
