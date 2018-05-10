//
//  MiniTabBarController.swift
//  dilidili-client
//
//  Created by YYInc on 2018/4/25.
//  Copyright © 2018年 caoxuerui. All rights reserved.
//

import Foundation
import UIKit

class MiniTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCustomTabBar()
    }

    private func createCustomTabBar() {
        let homeVC = HomeViewController()
        let homeItem = UITabBarItem.init(title: "首页", image: #imageLiteral(resourceName: "tab1"), selectedImage: nil)
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = homeItem
        
        let mineVC = MineViewController()
        let mineItem = UITabBarItem.init(title: "我的", image: UIImage.init(named: "tab2"), selectedImage: nil)
        let mineNav = UINavigationController.init(rootViewController: mineVC)
        mineNav.tabBarItem = mineItem

        self.viewControllers = [homeNav,mineNav]
    }
}
