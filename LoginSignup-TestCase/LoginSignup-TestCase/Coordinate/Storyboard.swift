//
//  Storyboard.swift
//  SignupLogin
//
//  Created by Ankita Kotadiya on 28/07/23.
//

import Foundation
import UIKit

protocol Storyboard {
    static func instantiate() -> Self
}

extension Storyboard where Self: UIViewController {
    
    static func instantiate() -> Self {
        let className = String(describing: Self.self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(identifier: className) as! Self
    }
}
