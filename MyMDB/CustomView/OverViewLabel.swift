//
//  OverViewLabel.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//
import UIKit

final class OverViewLabel: UILabel {
    func configureLabel(_ title: String, _ lines: Int) {
        text = title.isEmpty ? "상세설명이 제공되지 않습니다." : title
        numberOfLines = lines
        textColor = .lightGray
        font = .systemFont(ofSize: C.sizeSm)
        sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
