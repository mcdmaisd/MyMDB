//
//  GenreView.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import UIKit

final class GenreView: BaseView {
    private let label = UILabel()
    
    override func configureHierarchy() {
        addView(label)
    }
    
    override func configureLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
    }
    
    override func configureView() {
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = .darkGray
        
        label.font = .systemFont(ofSize: C.sizeMd)
        label.textColor = .customLightGray
    }
    
    func configureLabel(_ genre: String) {
        label.text = genre
    }
}
