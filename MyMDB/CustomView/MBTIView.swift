//
//  MBTIView.swift
//  MyMDB
//
//  Created by ilim on 2025-02-08.
//

import UIKit

class MBTIView: BaseView {
    private let MBTILabel = HeaderLabel()
    private let MBTIStackView = UIStackView()
    private let ESTJStackView = UIStackView()
    private let INFPStackView = UIStackView()
    
    override func configureHierarchy() {
        addView(MBTILabel)
        addView(MBTIStackView)
        MBTIStackView.addArrangedSubview(ESTJStackView)
        MBTIStackView.addArrangedSubview(INFPStackView)
    }
    
    override func configureLayout() {
        MBTILabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        MBTIStackView.snp.makeConstraints { make in
            make.leading.equalTo(MBTILabel.snp.trailing)
            make.top.trailing.equalToSuperview()
        }
    }
    
    override func configureView() {
        MBTILabel.configureData(C.MBTITitle)
        MBTILabel.textAlignment = .left
        
        configureStackView(.vertical, MBTIStackView)
        configureStackView(.horizontal, ESTJStackView)
        configureStackView(.horizontal, INFPStackView)
        
        configureSubview()
    }
    
    private func configureStackView(_ axis: NSLayoutConstraint.Axis, _ sv: UIStackView) {
        sv.axis = axis
        sv.spacing = C.stackViewSpacing
        sv.distribution = .fillEqually
        sv.alignment = .fill
    }
    
    private func configureSubview() {
        let subviews = [ESTJStackView, INFPStackView]
        let selectedKeys = U.shared.get(C.mbtiKey, C.defaultKey)
        
        for (i, mbti) in C.MBTIs.enumerated() {
            for (j, key) in mbti.enumerated() {
                let button = MBTIButton()
                button.configureButton(String(key), j, selectedKeys[i][j])
                subviews[i].addArrangedSubview(button)
            }
        }
    }
}
