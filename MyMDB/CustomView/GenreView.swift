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
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    override func configureView() {
        layer.cornerRadius = C.cornerRadius
        clipsToBounds = true
        backgroundColor = .gray
        
        label.font = .systemFont(ofSize: C.sizeMd)
        label.textColor = .lightGray
    }
    
    func configureLabel(_ genre: String) {
        label.text = genre
    }
}
