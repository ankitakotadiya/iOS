//
//  CellAddition.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerClassWithDefaultIdentifier(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeueReusableCellWithIdentifier<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Failed to dequeue a cell with identifier: \(String(describing: T.self)). Ensure that the cell is registered with the collection view.")
        }
        return cell
    }
}

extension UICollectionView {
    // Registers a cell class with the collection view using a default identifier.
    func registerClassWithDefaultIdentifier(cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    // Dequeues a reusable cell of the specified type using a default identifier.
    func dequeueReusableCellWithDefaultIdentifier<T: UICollectionViewCell>(_ indexpath: IndexPath) -> T {
        
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexpath) as? T else {
            fatalError("Failed to dequeue a cell with identifier: \(identifier). Ensure that the cell is registered with the collection view.")
        }
        
        return cell
    }
    
    func registerHeaderClassWithReusableIdentifier(cellClass: AnyClass) {
        register(cellClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeReusableSupplementryHeader<T: UICollectionReusableView>(_ indexpath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexpath) as? T else {
            fatalError("Failed to dequeue a cell with identifier: \(identifier). Ensure that the cell is registered with the collection view.")
        }
        return cell
    }
}

