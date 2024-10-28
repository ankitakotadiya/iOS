//
//  UIView.swift
//  DatePicker+Popups
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import Foundation
import UIKit

extension UIView {
    func loadNib() -> Self {
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
        guard let view =  nib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("Could not load view")
        }
        
        return view
    }
}
