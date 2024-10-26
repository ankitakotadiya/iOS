//
//  CellAddition.swift
//  Practice
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import Foundation
import UIKit

extension UITableView {
    func _registerTableviewCellwithIdentifier(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func _dequeReusableCellWithIdentifier<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Unable to deque reusable cell")
        }
        
        return cell
    }
}
