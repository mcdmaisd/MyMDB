//
//  MainViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

final class MainViewController: BaseViewController {
    private let infoView = UserInfoView()
    
    override func configureHierarchy() {
        addSubView(infoView)
    }
    
    override func configureLayout() {
        infoView.setInfoConstraint(self)
    }
    
    override func configureView() {
        infoView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(self, C.todayMovieTitle)
        configureRightBarButtonItem(self, nil, C.searchImage)
    }

    override func rightBarButtonTapped() {
        print(#function)
    }
}
