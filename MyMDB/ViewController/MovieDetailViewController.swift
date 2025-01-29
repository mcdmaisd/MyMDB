//
//  MovieDetailViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-29.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    private let likeButton = LikeButton()
    
    var result: Results?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let result else { return }
        
        configureNavigationTitle(self, result.title)
        configureLeftBarButtonItem(self)
        configureRightBarButtonItem(self)

        likeButton.configureButton(result.id)
        navigationItem.rightBarButtonItem?.customView = likeButton
    }
    
}
