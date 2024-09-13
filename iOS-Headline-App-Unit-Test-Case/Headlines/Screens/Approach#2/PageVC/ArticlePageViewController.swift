import UIKit

final class ArticlePageViewController: UIPageViewController {
    
    var articles: [Article] = [] // This will be filled with your API data
    var currentIndex: Int = 0
    weak var articledelegate: ArticleCollectionViewCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        if let firstViewController = viewControllerAtIndex(index: currentIndex) {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(index: Int) -> ArticleViewController? {
        if index >= 0 && index < articles.count {
            let articleViewController = ArticleViewController()
            articleViewController.article = articles[index]
            articleViewController.delegate = articledelegate
            return articleViewController
        }
        return nil
    }
}

// MARK: - UIPageViewControllerDataSource
extension ArticlePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let articleViewController = viewController as? ArticleViewController,
              let index = articles.firstIndex(where: { $0 == articleViewController.article }) else {
            return nil
        }
        let previousIndex = index - 1
        return viewControllerAtIndex(index: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let articleViewController = viewController as? ArticleViewController,
              let index = articles.firstIndex(where: { $0 == articleViewController.article }) else {
            return nil
        }
        let nextIndex = index + 1
        return viewControllerAtIndex(index: nextIndex)
    }
}






