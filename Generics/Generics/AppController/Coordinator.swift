//
//  coordinator.swift
//  Generics
//
//  Created by Ankita Kotadiya on 14/04/24.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
