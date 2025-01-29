//
//  DateLabel.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import UIKit

class CustomLabel: UILabel {
    func configureLabel(_ title: String = "") {
        text = title
        textColor = .gray
        font = .systemFont(ofSize: C.sizeMd)
        sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
