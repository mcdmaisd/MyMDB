//
//  MBTIButton.swift
//  MyMDB
//
//  Created by ilim on 2025-02-08.
//

import UIKit

class MBTIButton: BaseView {
    private(set) var button = UIButton()
        
    var keys: ((Bool) -> Void)?

    override func configureHierarchy() {
        addView(button)
    }
    
    override func configureLayout() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(button.snp.width)
        }
    }
    
    override func configureView() {
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    func configureButton(_ title: String, _ isSelected: Bool) {
        var config = UIButton.Configuration.filled()
        config.title = title
        button.configuration = config
        button.isSelected = isSelected
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.configurationUpdateHandler = {btn in
            switch btn.state {
            case .selected:
                btn.configuration?.baseForegroundColor = .customWhite
                btn.configuration?.baseBackgroundColor = .systemBlue
            default:
                btn.configuration?.baseForegroundColor = .customDarkGray
                btn.configuration?.baseBackgroundColor = .customWhite
            }
        }
    }
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        keys?(sender.isSelected)
    }
}
