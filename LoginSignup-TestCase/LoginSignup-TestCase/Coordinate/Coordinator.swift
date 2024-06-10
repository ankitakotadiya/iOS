//
//  Coordinator.swift
//  SignupLogin
//
//  Created by Ankita Kotadiya on 28/07/23.
//

import Foundation
import UIKit

protocol Coordinator {
    
    var navigationController: UINavigationController {get set}
    func start()
}
