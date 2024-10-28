//
//  UIViewController.swift
//  DatePicker+Popups
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import Foundation
import UIKit

extension UIViewController {
    func _instantiateViewControllerFromStoryBoard<T: UIViewController>() -> T {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Unable to load VC")
        }
        return vc
    }
    
    func _instantiateViewControllerFromXIB<T: UIViewController>() -> T {
        let vc = T(nibName: String(describing: T.self), bundle: nil)
        return vc
    }
}
