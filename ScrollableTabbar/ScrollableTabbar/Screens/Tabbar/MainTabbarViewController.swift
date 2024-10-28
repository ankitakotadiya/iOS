//
//  MainTabbarViewController.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 28/10/24.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    let homeVC: UINavigationController = {
        let vc = ViewController(viewModel: TabbarViewModel())
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()
    
    let settingsVC: UINavigationController = {
        let vc = SettingsViewController()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeVC.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "house"), tag: 0)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)

        viewControllers = [homeVC, settingsVC]
    }
}
