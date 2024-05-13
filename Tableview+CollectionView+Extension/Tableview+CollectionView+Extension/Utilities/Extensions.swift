//
//  Extensions.swift
//  Tableview+CollectionView+Extension
//
//  Created by Ankita Kotadiya on 13/05/24.
//

import Foundation
import UIKit


protocol Reusable: AnyObject {
    static var nib: UINib {get}
}

extension Reusable {
    static var nib: UINib {
        return UINib(nibName: String.className(for: self), bundle: Bundle.main)
    }
}

extension String {
    static func className(for classType: AnyClass) -> String {
        return String(describing: classType)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
        register(T.nib, forCellReuseIdentifier: String.className(for: cellType))
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type) where T: Reusable {
        register(T.nib, forCellWithReuseIdentifier: String.className(for: cellType))
    }
}

