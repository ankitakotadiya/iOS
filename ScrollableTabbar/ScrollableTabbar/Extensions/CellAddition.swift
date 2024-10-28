//
//  CellAddition.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import Foundation
import UIKit

extension UICollectionView {
    func _registerCollectionViewClassWithIdentifier(_ cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func _dequeueReusableCellWithIdentifier<T: UICollectionViewCell>(_ indexpath: IndexPath) -> T {
        let identiFier: String = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identiFier, for: indexpath) as? T else {
            fatalError("Failed to deque Cell with identifier: \(identiFier). Ensure cell is registered with collectionview.")
        }
        
        return cell
    }
}
