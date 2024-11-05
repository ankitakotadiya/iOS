//
// Copyright © 2024 ASOS. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableIdentifier {
    static var identifier: String { get }
}

extension ReusableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableIdentifier {}

extension UITableView {
    func _registerTableViewCellWithIdentifier<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func _dequeueReusableCellwithIdentifier<T: UITableViewCell>() -> T? {
        let cell = dequeueReusableCell(withIdentifier: T.identifier) as? T
        return cell
    }
}
