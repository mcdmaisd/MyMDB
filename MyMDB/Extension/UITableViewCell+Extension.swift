//
//  File.swift
//  NShopping
//
//  Created by ilim on 2025-01-15.
//

import UIKit

extension UITableViewCell {
    static func getId() -> String {
        return String(describing: self)
    }
        
    func flowLayout(direction: UICollectionView.ScrollDirection, itemCount: CGFloat, inset: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - (itemCount + 1) * inset) / itemCount
        
        layout.scrollDirection = direction
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        
        return layout
    }
}
