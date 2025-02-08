//
//  MBTIView.swift
//  MyMDB
//
//  Created by ilim on 2025-02-08.
//

import UIKit

class MBTIView: BaseView {
    private let mbtiLabel = HeaderLabel()
    private let mbtiStackView = UIStackView()
    private let estjStackView = UIStackView()
    private let infpStackView = UIStackView()
    
    private var buttons: [[MBTIButton]] = [[], []]
    
    private(set) var selectedKeys = U.shared.get(C.mbtiKey, C.defaultKey)
    
    override func configureHierarchy() {
        addView(mbtiLabel)
        addView(mbtiStackView)
        mbtiStackView.addArrangedSubview(estjStackView)
        mbtiStackView.addArrangedSubview(infpStackView)
    }
    
    override func configureLayout() {
        mbtiLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        mbtiStackView.snp.makeConstraints { make in
            make.leading.equalTo(mbtiLabel.snp.trailing)
            make.top.trailing.equalToSuperview()
        }
    }
    
    override func configureView() {
        mbtiLabel.configureData(C.MBTITitle)
        mbtiLabel.textAlignment = .left
        
        configureStackView(.vertical, mbtiStackView)
        configureStackView(.horizontal, estjStackView)
        configureStackView(.horizontal, infpStackView)
        
        configureSubview()
    }
    
    private func configureStackView(_ axis: NSLayoutConstraint.Axis, _ sv: UIStackView) {
        sv.axis = axis
        sv.spacing = C.stackViewSpacing
        sv.distribution = .fillEqually
        sv.alignment = .fill
    }
    
    private func configureSubview() {
        let subviews = [estjStackView, infpStackView]

        for (i, mbti) in C.MBTIs.enumerated() {
            for (j, key) in mbti.enumerated() {
                let button = configureButton(String(key), i, j)
                subviews[i].addArrangedSubview(button)
                buttons[i].append(button)
            }
        }
    }
    
    private func configureButton(_ key: String, _ row: Int, _ column: Int) -> MBTIButton {
        let section = row == 0 ? 1 : 0
        let button = MBTIButton()
        
        button.configureButton(key, selectedKeys[row][column])
        button.keys = { [weak self] key in
            self?.selectedKeys[row][column] = key
            if key {
                self?.selectedKeys[section][column] = false
                self?.buttons[section][column].button.isSelected = false
            }
        }
        
        return button
    }
}
