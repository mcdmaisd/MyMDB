//
//  UILabel+Extension.swift
//  MyMDB
//
//  Created by ilim on 2025-02-02.
//

import UIKit

extension UILabel {
    func setText(_ title: String, _ target: String) {
        if target.isEmpty {
            text = title
        } else {
            attributedText = title.changeColor(target)
        }
    }
    
    func configureLabel(_ title: String, _ line: Int, _ color: UIColor, _ target: String, _ fontSize: CGFloat) {
        textColor = color
        numberOfLines = line
        font = .systemFont(ofSize: fontSize)
        setText(title, target)
    }
}
