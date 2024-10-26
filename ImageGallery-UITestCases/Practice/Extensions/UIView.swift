//
//  UIView.swift
//  Practice
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import Foundation
import UIKit

extension UIView {
    func _addsubViews(_ subviews: UIView...) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}

extension UIStackView {
    func _addArrangedSubViews(_ subviews: UIView...) {
        for subview in subviews {
            addArrangedSubview(subview)
        }
    }
}
