//
//  UIViewController+Extension.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

extension UIViewController: SendTouchEvent {
    func changeRootView() {
        let window = UIApplication.shared.getCurrentScene()
        let isNotFirst = U.shared.get(C.firstKey, false)
        let onBoarding = UINavigationController(rootViewController: OnboardingViewController())
        let vc = isNotFirst ? onBoarding : TabBarController()
        
        U.shared.set(!isNotFirst, C.firstKey)
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    func flowLayout(direction: UICollectionView.ScrollDirection, itemCount: CGFloat, inset: CGFloat, _ widthRatio: CGFloat = 1, _ heightRatio: CGFloat = 1, ratio: CGFloat = 1) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIApplication.shared.getCurrentScene().bounds.width * ratio
        let itemWidth = (screenWidth - (itemCount + 1) * inset) / itemCount
        
        layout.scrollDirection = direction
        layout.itemSize = CGSize(width: itemWidth * widthRatio, height: itemWidth * heightRatio)
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: inset, right: inset)
        
        return layout
    }
    
    func remakeFlowlayout(_ cv: UICollectionView, widthRatio: CGFloat = 1, heightRatio: CGFloat = 1) {
        guard let cell = cv.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidth = cv.frame.width * widthRatio
        let cellHeight = cv.frame.height * heightRatio
        
        if cell.itemSize.width == cellWidth && cell.itemSize.height == cellHeight { return }
        
        cell.itemSize = CGSize(width: cellWidth, height: cellHeight)
        cell.invalidateLayout()
    }
    
    func presentAlert(_ title: String?, _ message: String, _ delete: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if delete {
            alert.addAction(UIAlertAction(title: C.cancelActionTitle, style: .cancel))
        }
        
        alert.addAction(UIAlertAction(title: C.okActionTitle, style: .default, handler: { action in
            if delete {
                self.changeRootView()
                self.removeAllUserDefaults()
            }
        }))
        
        present(alert, animated: true)
    }
    
    func configureTableView(_ tv: UITableView) {
        tv.backgroundColor = .clear
        tv.tableHeaderView = UIView()
        tv.separatorInset = UIEdgeInsets.zero
        tv.separatorColor = .customDarkGray.withAlphaComponent(C.unselectedAlpha)
    }
    
    func configureNavigationTitle(_ vc: UIViewController, _ title: String) {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .customBlack
        appearance.titleTextAttributes = [.foregroundColor: UIColor.customWhite]
        
        vc.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        vc.navigationController?.navigationBar.standardAppearance = appearance
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
    
    func sheetPresent() {
        let vc = UINavigationController(rootViewController: SetProfileViewController())
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    func checkDuplication(_ data: [TMDBMovieInfo]) {
        let list = data.map { $0.id }
        let setList = Set(list)
        print("result:", list.count == setList.count, "list count: \(list.count), set count: \(setList.count)")
    }
    
    func moveToDetailVC(_ from: UIViewController, _ data: TMDBMovieInfo) {
        let vc = MovieDetailViewController()
        vc.viewModel.input.movieInfo.value = data
        from.navigationController?.pushViewController(vc, animated: true)
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
