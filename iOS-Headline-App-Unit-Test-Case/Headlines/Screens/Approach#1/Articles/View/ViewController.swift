import UIKit
import SDWebImage

final class ViewController: UIViewController {
//    @IBOutlet var imageView: UIImageView!
//    @IBOutlet var headlineLabel: UILabel!
//    @IBOutlet var bodyLabel: UILabel!
    
    private let viewModel: ArticlesViewProvider
    var mainCoordinator : ArticlesChildCoordinator?
    
    init(viewModel: ArticlesViewProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ArticlesView()
    }
    
    lazy var contentView: ArticlesView? = {
        return self.view as? ArticlesView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let articleView = self.view as? ArticlesView {
            self.configureCollectionView()
//        }
        self.title = "Articles"
        bindViewModel()
        self.viewModel.fetchArticles()
    }
    
    private func bindViewModel() {
        viewModel.updatedState = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateFromViewModel()
            }
        }
    }
    
    private func updateFromViewModel() {
        switch viewModel.state {
        case .loading, .loaded:
            self.reloadData()
        case .error(let error):
            showError(error)
        }
    }
    
    private func showError(_ message: String) {
        self.displayAlert(message: message, actionTitle: "Okay")
    }
    
    private func configureCollectionView() {
        contentView?.collectionView.dataSource = self
        contentView?.collectionView.delegate = self
        
        contentView?.collectionView.dm_registerClassWithDefaultIdentifier(cellClass: ArticlesCollectionViewCell.self)
    }
    
    private func reloadData() {
        contentView?.collectionView.reloadData()
    }
    
    final class ArticlesView: UIView {
        var collectionView: UICollectionView
        private let layoutSize: CGSize
        private var contentStackView = UIStackView()
        
        private let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            return scrollView
        }()
        
        private let buttons: UIButton = {
            let button = UIButton(type: .system)
            button.titleLabel?.text = "Favourite"
            button.backgroundColor = .blue
            return button
        }()
        
        override init(frame: CGRect) {
            
            layoutSize = CGSize(width: 200, height: 200)
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
            super.init(frame: frame)
            self.commonInit()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func commonInit() {
            self.setUpViewHierarchy()
            
            self.backgroundColor = .white
            collectionView.backgroundColor = .white
            collectionView.isPagingEnabled = true
            
            contentStackView.axis = .vertical
            contentStackView.spacing = 10
            
            self.activateConstraints()
        }
        
        private func setUpViewHierarchy() {
            contentStackView.dm_addArrangedSubviews(collectionView)
            self.addSubview(contentStackView)
        }
        
        func activateConstraints() {
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            ])
        }
    }
    
//    func reload() {
//        guard let article = Article.all.first else { return }
//        headlineLabel.text = article.headline
//        bodyLabel.text = article.body
//        imageView.sd_setImage(with: article.imageURL)
//    }

    @IBAction func favouritesButtonPressed() {
        let vc = FavouritesViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    @IBAction func starButtonPressed() {
        // TODO: Handle favouriting
    }
}

// MARK: - ArticleCollectionViewCellDelegate
extension ViewController: ArticleCollectionViewCellDelegate {
    func addToFavourite(for article: Article) {
        viewModel.updateObject(for: article)
    }
    
    func didRequestToOpenFavoritesList() {
        mainCoordinator?.navigateToFavouritesVC()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ArticlesCollectionViewCell = collectionView.dm_dequeueReusableCellWithDefaultIdentifier(indexPath)
        let article = viewModel.state.articles[indexPath.item]
        cell.article = article
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {  
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height) // Adjust size if needed
    }
}


