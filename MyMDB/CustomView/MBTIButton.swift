//
//  MBTIButton.swift
//  MyMDB
//
//  Created by ilim on 2025-02-08.
//

import UIKit

class MBTIButton: BaseView {
    private let button = UIButton()
    
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
    
    func configureButton(_ title: String, _ id: Int, _ isSelected: Bool) {
        var config = UIButton.Configuration.filled()
        config.title = title
        button.configuration = config
        button.tag = id
        button.isSelected = isSelected
        button.addTarget(self, action: #selector(buttonTappedd), for: .touchUpInside)
        button.configurationUpdateHandler = { btn in
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
    private func buttonTappedd(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
