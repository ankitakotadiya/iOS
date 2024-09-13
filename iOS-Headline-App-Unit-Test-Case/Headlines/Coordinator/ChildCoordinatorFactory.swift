import Foundation
import UIKit

enum childCoordinatorType {
    case article
    case favourite
}

class ChildCoordinatorFactory {
    static func create(with _navigationController: UINavigationController, type: childCoordinatorType) -> ChildCoordinator {

        switch type {
        case .article:
            return ArticlesChildCoordinator(with: _navigationController)
        case .favourite:
            return FavouritesChildCoordinators(with: _navigationController) 
        }
    }
}
