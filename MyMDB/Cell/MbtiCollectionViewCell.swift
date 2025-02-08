//
//  MbtiCollectionViewCell.swift
//  MyMDB
//
//  Created by ilim on 2025-02-09.
//

import UIKit

class MbtiCollectionViewCell: BaseCollectionViewCell {
    static let id = getId()
    
    private let mbtiLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(mbtiLabel)
    }
    
    override func configureLayout() {
        mbtiLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .clear
        
        mbtiLabel.font = .systemFont(ofSize: C.sizeXl)
        mbtiLabel.textAlignment = .center
        mbtiLabel.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mbtiLabel.layer.cornerRadius = mbtiLabel.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mbtiLabel.text = nil
    }
    
    private func changeColor(_ selected: Bool) {
        if selected {
            mbtiLabel.textColor = .white
            mbtiLabel.backgroundColor = .customTheme
        } else {
            mbtiLabel.textColor = .gray
            mbtiLabel.backgroundColor = .white
        }
    }
        
    func configureLabel(_ key: String, _ selected: Bool) {
        mbtiLabel.text = key
        changeColor(selected)
    }
}
