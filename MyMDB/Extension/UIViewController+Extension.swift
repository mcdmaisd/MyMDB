//
//  UIViewController+Extension.swift
//  SeSACDay22Assignment
//
//  Created by ilim on 2025-01-23.
//

import UIKit

extension UIViewController {
    func changeRootView() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else { return }

        let isNotFirst = UserDefaults.standard.bool(forKey: C.first)
        let rootVC = isNotFirst ? OnboardingViewController() : ProfileViewController()
        
        UserDefaults.standard.set(!isNotFirst, forKey: C.first)
        
        window.rootViewController = UINavigationController(rootViewController: rootVC)
        window.makeKeyAndVisible()
    }
    
    func presentAlert(message: String?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.okActionTitle, style: .default))
        present(alert, animated: true)
    }
}
