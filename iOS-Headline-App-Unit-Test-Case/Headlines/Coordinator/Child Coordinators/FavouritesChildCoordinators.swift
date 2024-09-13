import Foundation
import UIKit

class FavouritesChildCoordinators : ChildCoordinator {
    var childCoordinator: [ChildCoordinator] = [ChildCoordinator]()
    var navigationController: UINavigationController
    var parentCoordinator: ParentCoordinator?
    
    init(with _navigationController: UINavigationController){
        self.navigationController = _navigationController
    }
    
    func configureChildViewController() {
        let viewModel = FavouritesViewModel()
        let favouriteVC = FavouritesViewController(viewModel: viewModel)
        favouriteVC.favouriteCoordinator = self
        
        let navController = UINavigationController(rootViewController: favouriteVC)
        navController.modalPresentationStyle = .fullScreen
        navController.setupNavigationAppearance()
        
        self.navigationController.present(navController, animated: true)
        self.navigationController = navController
    }
    
    func dismissView() {
        self.navigationController.dismiss(animated: true)
        self.didRemoveChild()
    }
    
    func didRemoveChild() {
        parentCoordinator?.removeChildCoordinator(child: self)
    }
}
