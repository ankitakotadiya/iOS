import UIKit

final class LoadingViewController: UIViewController {
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        activityIndicatorView = UIActivityIndicatorView(style: .medium)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                activityIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                activityIndicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ]
        )
        self.view = view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicatorView.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicatorView.stopAnimating()
    }
}

final class LoadingIndicatorManager {
    static let shared = LoadingIndicatorManager()
    private var indicator: UIActivityIndicatorView?
    
    private init() {}
    
    func showLoading(on view: UIView) {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        indicator.startAnimating()
        self.indicator = indicator
    }
    
    func stopAnimating() {
        indicator?.stopAnimating()
//        indicator?.removeFromSuperview()
        indicator = nil
    }
}
