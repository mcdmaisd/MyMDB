//
//  MainViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

class MainViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(self, C.todayMovieTitle)
        configureRightBarButtonItem(self, nil, C.searchImage)
    }
    
    override func rightBarButtonTapped() {
        print(#function)
    }


}
