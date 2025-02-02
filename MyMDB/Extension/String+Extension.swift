//
//  String+Extension.swift
//  MyMDB
//
//  Created by ilim on 2025-02-01.
//

import UIKit

extension String {
    func changeColor(_ text: String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        let regex = try? NSRegularExpression(pattern: text, options: .caseInsensitive)
        let matches = regex?.matches(in: self, range: NSRange(location: 0, length: self.utf16.count))

        matches?.forEach { match in
            attributeString.addAttribute(.foregroundColor, value: UIColor.systemPink, range: match.range)
        }
        
        return attributeString
    }
}
