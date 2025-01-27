//
//  UIView+Extension.swift
//  MyMDB
//
//  Created by ilim on 2025-01-26.
//

import UIKit
import SnapKit

extension UIView {
    func setProfileConstraint(_ vc: UIViewController) {
        self.snp.makeConstraints { make in
            make.width.equalTo(vc.view.safeAreaLayoutGuide).dividedBy(4)
            make.height.equalTo(self.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(vc.view.safeAreaLayoutGuide).offset(10)
        }
    }
    
    func setInfoConstraint(_ vc: UIViewController) {
        self.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(vc.view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(self.snp.width).dividedBy(3)
        }
    }
    
    func postNotification(_ value: Bool) {
        NotificationCenter.default.post(
            name: NSNotification.Name(C.userInfoChanged), object: nil, userInfo: [C.userInfoKey: value]
        )
    }
}
