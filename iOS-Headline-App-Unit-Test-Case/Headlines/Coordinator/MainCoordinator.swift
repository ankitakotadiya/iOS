import Foundation
import UIKit

class MainCoordinator: ParentCoordinator {
    
    var childCoordinator: [ChildCoordinator] = [ChildCoordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setupNavigationAppearance()
    }
    
    func configureRootViewController() {
        let articlesCoordinator = ChildCoordinatorFactory.create(with: self.navigationController, type: .article)
        childCoordinator.append(articlesCoordinator)
        articlesCoordinator.parentCoordinator = self
        articlesCoordinator.configureChildViewController()
    }
    
    func removeChildCoordinator(child: ChildCoordinator) {
        for(index, coordinator) in childCoordinator.enumerated() {
            if(coordinator === child) {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
}
