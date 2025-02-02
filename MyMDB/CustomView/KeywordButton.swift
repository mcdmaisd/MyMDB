//
//  KeywordButton.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import UIKit

final class KeywordButton: UIButton {
    private let title: String
    private let id: Int
    
    init(_ title: String, _ id: Int) {
        self.title = title
        self.id = id
        super.init(frame: .zero)
        configureButton()
    }
    
    private func configureButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: C.sizeSm)

        var config = UIButton.Configuration.filled()
        config.preferredSymbolConfigurationForImage = imageConfig
        config.baseBackgroundColor = .lightGray
        config.baseForegroundColor = .customBlack
        config.imagePlacement = .trailing
        config.buttonSize = .small
        config.cornerStyle = .capsule
        config.title = title
        config.titleAlignment = .automatic
        config.image = UIImage(systemName: C.xmark)
        config.imagePadding = 5
        configuration = config
        self.tag = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
