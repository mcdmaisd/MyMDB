//
//  LabelButton.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import UIKit

final class LabelButton: UIButton {
    private let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configureButton()
    }
    
    private func configureButton() {
        setTitle(title, for: .normal)
        setTitleColor(.customTheme, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: C.sizeMd)
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
