//
//  UIButton.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 18/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
// Configures the button's appearance and properties.
    func configure(font: UIFont? = nil, titleColor: UIColor? = nil, title: String? = nil, imageName: String? = nil, tintColor: UIColor? = nil, semanticContentAttribute: UISemanticContentAttribute? = nil) {
        
        if let font = font {
            self.titleLabel?.font = font
        }
        if let titleColor = titleColor {
            self.setTitleColor(titleColor, for: .normal)
        }
        if let title = title {
            self.setTitle(title, for: .normal)
        }
        if let imagename = imageName {
            self.setImage(UIImage.asset(imagename), for: .normal)
        }
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        if let semanticAttribute = semanticContentAttribute {
            self.semanticContentAttribute = semanticAttribute
        }
    }
    
// Adjusts the spacing between the button's title and image.
    func setTitleAndImageSpacing(_ spacing: CGFloat) {
        let insetAmount = spacing / 2
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
