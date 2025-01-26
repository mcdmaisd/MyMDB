//
//  UIView+Extension.swift
//  MyMDB
//
//  Created by ilim on 2025-01-26.
//

import UIKit
import SnapKit

extension UIView {
    func setConstraint(_ vc: UIViewController) {
        self.snp.makeConstraints { make in
            make.width.equalTo(vc.view.safeAreaLayoutGuide).dividedBy(4)
            make.height.equalTo(self.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(vc.view.safeAreaLayoutGuide).offset(10)
        }
    }
}
