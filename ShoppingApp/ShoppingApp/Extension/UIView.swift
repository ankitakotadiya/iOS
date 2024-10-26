//
//  UIView.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
//

import Foundation
import UIKit

extension UIView {
    func addSubViews(_ subviews: UIView...) {
        for subview in subviews {
            addSubview(subview)
        }
    }
    
    func _applyCornerRadius(radius: CGFloat = 8.0, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
}

extension UIStackView {
    func addArrangedSubViews(_ subviews: UIView...) {
        for subview in subviews {
            addArrangedSubview(subview)
        }
    }
}
