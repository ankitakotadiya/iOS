//
//  CellAddition.swift
//  CompositeCollectionView
//
//  Created by Ankita Kotadiya on 03/11/24.
//

import Foundation
import UIKit

extension UICollectionView {
    func _registerCellWithIdentifier<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass.self, forCellWithReuseIdentifier: String(describing: cellClass.self))
    }
    
    func _dequeReusableCellWithIdentifier<T: UICollectionViewCell>(_ indexpath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexpath) as? T else {
            fatalError("Unable to load cell")
        }
        return cell
    }
    
    func _registerHeaderViewwithIdentifier<T: UICollectionReusableView>(_ viewClass: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self))
    }
    
    func _dequeReusableHeaderWithIdentifier<T: UICollectionReusableView>(_ indexpath: IndexPath) -> T {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexpath) as? T else {
            fatalError("Unable to load")
        }
        
        return header
    }
}
