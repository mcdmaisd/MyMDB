//
//  CustomLabel.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import UIKit

final class HeaderLabel: UILabel {
    func configureData(_ title: String = "", _ line: Int = 1, _ target: String = "") {
        configureLabel(title, line, target, C.sizeXl, true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
