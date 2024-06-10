//
//  MainCoordinator.swift
//  SignupLogin
//
//  Created by Ankita Kotadiya on 28/07/23.
//

import Foundation
import UIKit


class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        let vc = ViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
}

