//
//  UIViewController.swift
//  CompositeCollectionView
//
//  Created by Ankita Kotadiya on 03/11/24.
//

import Foundation
import UIKit

extension UIViewController {
    static func _instantiateViewController<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let vc = storyboard.instantiateViewController(identifier: String(describing: T.self)) as? T else {
            fatalError("Failed to load")
        }
        return vc
    }
}
