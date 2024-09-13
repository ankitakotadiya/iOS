import Foundation
import UIKit

extension UINavigationController {
    
    func setupNavigationAppearance() {
        view.backgroundColor = .white
        navigationBar.prefersLargeTitles = false
        navigationBar.barTintColor = .white
        navigationBar.tintColor = UIColor.Brand.popsicle40
        navigationBar.barStyle = .default
        navigationBar.isTranslucent = false
    }
}

extension UISearchBar {
    func setCenteredPlaceHolder(isOffset: Bool) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        
        //get the sizes
        let searchBarWidth = self.frame.width
        let placeholderIconWidth = textFieldInsideSearchBar?.leftView?.frame.width
        let placeHolderWidth = textFieldInsideSearchBar?.attributedPlaceholder?.size().width
        let offsetIconToPlaceholder: CGFloat = 8
        let placeHolderWithIcon = placeholderIconWidth! + offsetIconToPlaceholder
        
        let offsetH = isOffset ? ((searchBarWidth / 2) - (placeHolderWidth! / 2) - placeHolderWithIcon) : 0
        let offset = UIOffset(horizontal: offsetH, vertical: 0)
        self.setPositionAdjustment(offset, for: .search)
    }
}
