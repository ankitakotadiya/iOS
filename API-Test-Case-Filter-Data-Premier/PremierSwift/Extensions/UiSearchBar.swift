//
//  UiSearchBar.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 17/09/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    func setupLeaftImage(_ image: UIImage?) {
        guard let image = image else {
            searchTextField.leftView = nil
            return
        }
        
        let imgView: UIImageView = UIImageView(image: image)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: 24),
            imgView.heightAnchor.constraint(equalToConstant: 24),
        ])
        imgView.tintColor = tintColor
        searchTextField.leftView = imgView
    }
}
