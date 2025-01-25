//
//  CustomButton.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

final class CustomButton: UIButton {
    
    private let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configureButton()
    }
    
    private func configureButton() {
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: C.sizeLg)

        config.buttonSize = .large
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString(title, attributes: titleContainer)
        config.background.strokeColor = .customTheme
        config.baseForegroundColor = .customTheme
        config.baseBackgroundColor = .clear

        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
