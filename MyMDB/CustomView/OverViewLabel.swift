//
//  OverViewLabel.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//
import UIKit

final class OverViewLabel: UILabel {
    func configureLabel(_ title: String = "", _ lines: Int = 1) {
        text = title.isEmpty ? C.emptyOverView : title
        numberOfLines = lines
        textColor = .lightGray
        font = .systemFont(ofSize: C.sizeSm)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
