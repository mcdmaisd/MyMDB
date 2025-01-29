//
//  KeywordButton.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//

import UIKit

final class KeywordButton: UIButton {
    func configureButton(_ title: String, _ tag: Int) {
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
        self.tag = tag
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
