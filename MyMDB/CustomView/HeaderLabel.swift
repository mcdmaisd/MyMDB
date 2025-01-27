//
//  CustomLabel.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import UIKit

final class HeaderLabel: UILabel {
    private let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configureLabel()
    }
    
    private func configureLabel() {
        textColor = .customWhite
        font = .boldSystemFont(ofSize: C.sizeXl)
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
