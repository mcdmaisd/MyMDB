//
//  UIViewController+Extension.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

extension UIViewController {
    func changeRootView() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else { return }

        let isNotFirst = UserDefaults.standard.bool(forKey: C.firstKey)
        let onBoarding = UINavigationController(rootViewController: OnboardingViewController())
        let vc = isNotFirst ? onBoarding : TabBarController()
        
        UserDefaults.standard.set(!isNotFirst, forKey: C.firstKey)
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    func flowLayout(_ count: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let numberOfItemsInLine: CGFloat = count
        let inset: CGFloat = 5
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - (numberOfItemsInLine + 1) * inset) / numberOfItemsInLine
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        return layout
    }
    
    func presentAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: C.cancelActionTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: C.okActionTitle, style: .default, handler: { action in
            self.changeRootView()
            self.removeAllUserDefaults()
        }))
        present(alert, animated: true)
    }
    
    func configureNavigationBar(_ vc: UIViewController, _ title: String) {
        vc.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.customWhite]
        vc.navigationItem.title = title
    }
    
    func configureLeftBarButtonItem(_ vc: UIViewController) {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(back))
        let image = UIImage(systemName: Constants.backward)
        
        backBarButtonItem.tintColor = .customTheme
        backBarButtonItem.image = image

        vc.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func configureRightBarButtonItem(_ vc: UIViewController ,_ title: String? = nil, _ image: String? = nil) {
        let barButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
        barButtonItem.tintColor = .customTheme
        
        if let image {
            let buttonImage = UIImage(systemName: image)
            barButtonItem.image = buttonImage
        }

        vc.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func configureToolbar(_ sender: UITextField) {
        let toolbar = UIToolbar()
        let nilButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(dismissKeyboard))
        
        doneButton.image = UIImage(systemName: C.dismissKeyboardImage)
        
        toolbar.items = [nilButton, doneButton]
        toolbar.backgroundColor = .customWhite
        toolbar.tintColor = .customBlack
        toolbar.sizeToFit()
        
        sender.inputAccessoryView = toolbar
    }
    
    func removeAllUserDefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }

    @objc
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc
    func rightBarButtonTapped() { }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
