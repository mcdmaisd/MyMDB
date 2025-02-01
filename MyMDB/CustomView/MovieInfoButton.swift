//
//  MovieInfoButton.swift
//  MyMDB
//
//  Created by ilim on 2025-01-30.
//

import UIKit

final class MovieInfoButton: UIButton {
    private let title: String
    private let image: String

    init(title: String, image: String) {
        self.title = title
        self.image = image
        super.init(frame: .zero)
        configureButton()
    }
   
    private func configureButton() {
        let container = AttributeContainer().font(.systemFont(ofSize: C.sizeXs))
        let imageConfig = UIImage.SymbolConfiguration(pointSize: C.sizeXs)
        let title = self.title.isEmpty ? C.noInfo : self.title
        var config = UIButton.Configuration.filled()
        config.preferredSymbolConfigurationForImage = imageConfig
        config.baseBackgroundColor = .customBlack
        config.baseForegroundColor = .gray
        config.buttonSize = .mini
        config.imagePadding = 5
        config.background.cornerRadius = .zero
        config.cornerStyle = .fixed
        config.image = UIImage(systemName: image)
        config.attributedTitle = AttributedString(title, attributes: container)
        configuration = config
        isUserInteractionEnabled = false
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
