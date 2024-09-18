import UIKit

extension String {
    /// Returns the name of the class as a string.
    static func className(for classType: AnyClass) -> String {
        return String(describing: classType)
    }
}

extension UITableView {
    // Registers a cell class with the table view using a default identifier.
    func dm_registerClassWithDefaultIdentifier(cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String.className(for: cellClass))
    }
    
    func dm_registerHeaderFooterClassWithDefaultIdentifier(headerClass: AnyClass) {
        register(headerClass, forHeaderFooterViewReuseIdentifier: String.className(for: headerClass))
    }
    
    // Dequeues a reusable cell of the specified type using a default identifier.
    func dm_dequeueReusableCellWithDefaultIdentifier<T: UITableViewCell>() -> T {
        // swiftlint:disable:next force_cast
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("Failed to dequeue a cell with identifier: \(identifier). Ensure that the cell is registered with the collection view.")
        }
        return cell
    }
    
    // Dequeues a reusable cell of the specified type using a default identifier.
    func dm_dequeueReusableHeaderFooterWithDefaultIdentifier<T: UITableViewHeaderFooterView>() -> T {
        // swiftlint:disable:next force_cast
        let identifier = String(describing: T.self)
        guard let headerView = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("Failed to dequeue a cell with identifier: \(identifier). Ensure that the cell is registered with the collection view.")
        }
        return headerView
    }
}

extension UICollectionView {
    // Registers a cell class with the collection view using a default identifier.
    func dm_registerClassWithDefaultIdentifier(cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String.className(for: cellClass))
    }
    
    // Dequeues a reusable cell of the specified type using a default identifier.
    func dm_dequeueReusableCellWithDefaultIdentifier<T: UICollectionViewCell>(_ indexpath: IndexPath) -> T {
        
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexpath) as? T else {
            fatalError("Failed to dequeue a cell with identifier: \(identifier). Ensure that the cell is registered with the collection view.")
        }
        
        return cell
    }
}
