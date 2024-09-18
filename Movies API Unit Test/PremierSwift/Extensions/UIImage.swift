//
//  UIImage.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 18/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation
import UIKit

// Set image across the app using asset property.
extension UIImage {
   static var asset: (String) -> UIImage? {
        return { imagename in
            return UIImage(named: imagename)?.withRenderingMode(.alwaysTemplate)
        }
    }
}
