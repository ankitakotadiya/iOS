import Foundation
import UIKit

class ArticlesChildCoordinator: ChildCoordinator {
    var childCoordinator: [ChildCoordinator] = [ChildCoordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
    
    init(with _navigationController: UINavigationController){
        self.navigationController = _navigationController
    }
    
    func configureChildViewController() {
        let viewModel = ArticlesViewModel()
        // Use ArticlesViewController here if you want to verify using Collectionview
        let vc = ViewController(viewModel: viewModel)
        vc.mainCoordinator = self
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func navigateToFavouritesVC() {
        let favouritesCoordinator = ChildCoordinatorFactory.create(with: self.navigationController, type: .favourite)
        favouritesCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinator.append(favouritesCoordinator)
        parentCoordinator?.removeChildCoordinator(child: self)
        favouritesCoordinator.configureChildViewController()
    }
}
