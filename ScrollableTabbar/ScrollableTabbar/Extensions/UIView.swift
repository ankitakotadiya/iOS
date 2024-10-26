//
//  UIView.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import Foundation
import UIKit

extension UIView {
    func _addSubViews(_ subviews: UIView...) {
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
    func _addArrangedSubViews(_ subviews: UIView...) {
        for subview in subviews {
            addArrangedSubview(subview)
        }
    }
}

