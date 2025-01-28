//
//  CustomLabel.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import UIKit

final class HeaderLabel: UILabel {
    func configureLabel(_ title: String) {
        text = title
        textColor = .white
        font = .boldSystemFont(ofSize: C.sizeXl)
        sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
