//
//  UIViewController.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 18/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation
import UIKit

// Extends UIViewController to include a method for displaying a customizable alert with a title, message, and action button.
extension UIViewController {
    func displayAlert(title: String? = "", message: String? = nil, actionTitle: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
