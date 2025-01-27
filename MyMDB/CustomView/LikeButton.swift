//
//  LikeButton.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import UIKit

final class LikeButton: BaseView {
    private let button = UIButton()
    override func configureHierarchy() {
        addView(button)
    }
    
    override func configureLayout() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .customTheme
        button.configuration = config
        button.isSelected = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.configurationUpdateHandler = { btn in
            switch btn.state {
            case .selected:
                btn.configuration?.image = UIImage(systemName: C.heartFill)
            default:
                btn.configuration?.image = UIImage(systemName: C.heart)
            }
        }
    }
    
    func configureButton(_ id: Int) {
        button.tag = id
    }
    
    private func changeValue(_ button: UIButton) {
        let tag = button.tag
        var list = U.shared.get(C.movieCountKey) as? [Int] ?? []
        
        if button.isSelected {
            list.append(tag)
        } else {
            guard let element = list.firstIndex(of: tag) else {
                print("nil")
                return
            }
            list.remove(at: element)
        }
        
        U.shared.set(list, C.movieCountKey)
        postNotification(false)
    }
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        changeValue(button)
    }
}
