//
//  Fonts+Colors.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
//

import Foundation
import UIKit

extension UIColor {
    enum Brand {
        static let appColor: UIColor = UIColor(red: 22 / 255.0, green: 22 / 255.0, blue: 22 / 255.0, alpha: 1)
        static let extraLightGray: UIColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
    }
    
}

extension UIFont {
    
    enum Heading {
        static var medium: UIFont = UIFont.systemFont(ofSize: 28, weight: .semibold)
        static let small: UIFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
        static let xSmall: UIFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    enum Body {
        static var small: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        static var medium: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        static var smallSemiBold:UIFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static var xSmall: UIFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
}
