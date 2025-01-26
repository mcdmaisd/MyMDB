//
//  TabBar.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabs = [MainViewController(), UpcomingViewController(), ProfileViewController()]
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .customBlack
        appearance.selectionIndicatorTintColor = .customTheme
        
        tabBar.standardAppearance = appearance

        for (i, tab) in tabs.enumerated() {
            tab.tabBarItem = UITabBarItem(
                title: C.tabbarTitles[i],
                image: UIImage(systemName: C.tabbarImages[i]),
                tag: i
            )
        }

        viewControllers = tabs.map { UINavigationController(rootViewController: $0) }
    }
}
