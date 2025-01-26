//
//  SettingTableViewCell.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import UIKit

final class SettingTableViewCell: BaseTableViewCell {
    private let settingLabel = UILabel()
    
    static let id = getId()
    
    override func configureHierarchy() {
        addSubView(settingLabel)
    }
    
    override func configureLayout() {
        settingLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        settingLabel.backgroundColor = .customBlack
        settingLabel.font = .systemFont(ofSize: C.sizeXl)
        settingLabel.textColor = .customWhite
        settingLabel.textAlignment = .left
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        settingLabel.text = nil
    }
    
    func configureLabel(_ title: String) {
        settingLabel.text = title
    }
}
