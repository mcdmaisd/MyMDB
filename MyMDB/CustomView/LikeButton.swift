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
    
    func configureButton(_ id: Int = 0) {
        let list = U.shared.get(C.movieCountKey, [Int]())
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .customTheme
        button.configuration = config
        button.tag = id
        button.isSelected = list.contains(button.tag)
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
        
    private func changeValue(_ button: UIButton) {
        let tag = button.tag
        var list = U.shared.get(C.movieCountKey, [Int]())
        
        if button.isSelected {
            list.append(tag)
        } else {
            guard let element = list.firstIndex(of: tag) else {
                print(C.nilValue)
                return
            }
            list.remove(at: element)
        }
        
        presentToast(C.likeButtonMessages[button.isSelected] ?? "")
        U.shared.set(list, C.movieCountKey)
        postNotification(C.userInfoChanged, false, tag)
    }
        
    @objc
    private func buttonTapped(_ sender: UIButton) {
        button.isSelected.toggle()
        changeValue(button)
    }
}
