//
//  UILabel+Extension.swift
//  MyMDB
//
//  Created by ilim on 2025-02-01.
//

import UIKit

extension String {
    func changeColor(_ text: String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.foregroundColor, value: UIColor.systemPink, range: (self as NSString).range(of: text))
        return attributeString
    }
}
