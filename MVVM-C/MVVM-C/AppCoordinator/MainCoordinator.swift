//
//  MainCoordinator.swift
//  CarviOSTask
//
//  Created by Ankita Kotadiya on 30/07/23.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ViewController.instantiate() //This code can be reused while initiating view controller
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
