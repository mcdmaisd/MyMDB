//
//  UIView+Extension.swift
//  MyMDB
//
//  Created by ilim on 2025-01-26.
//

import UIKit
import Toast

extension UIView {
    func presentToast(_ message: String) {
        var style = ToastStyle()
        
        style.messageColor = .customWhite
        style.backgroundColor = .customTheme
        
        let window = UIApplication.shared.getCurrentScene()
        let center = CGPoint(x: window.bounds.midX, y: window.bounds.midY)

        window.makeToast(message, duration: 2, point: center, title: nil, image: nil, style: style, completion: nil)
    }
}
