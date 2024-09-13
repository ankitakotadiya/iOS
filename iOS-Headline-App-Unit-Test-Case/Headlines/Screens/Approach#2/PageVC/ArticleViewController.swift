import UIKit

final class ArticleViewController: UIViewController {
    
    var article: Article?
    weak var delegate: ArticleCollectionViewCellDelegate?
    
    private var contentView: ArticlesContentView? {
        return self.view as? ArticlesContentView
    }
    
    override func loadView() {
        self.view = ArticlesContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpActions()
        self.configureCell(with: article)
    }
    
    private func setUpActions() {
        self.contentView?.starButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        self.contentView?.favouriteButton.addTarget(self, action: #selector(favouritesButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func startButtonTapped(_ sender: UIButton) {
        guard let objArticle = article else {return}
        let imageName = objArticle.isFavourite ? Images.Articles.favouriteOff : Images.Articles.favouriteOn
        sender.setImage(UIImage(named: imageName), for: .normal)
        self.delegate?.addToFavourite(for: objArticle)
    }
    
    @objc func favouritesButtonTapped(_ sender: UIButton) {
        self.delegate?.didRequestToOpenFavoritesList()
    }
}

// MARK: - ConfigureCell
extension ArticleViewController {
    func configureCell(with article: Article?) {
        guard let objArticle = article else {return}
        contentView?.imageView.sd_setImage(with: objArticle.imageURL)
        contentView?.titleLabel.text = objArticle.headline
        contentView?.bodyLabel.text = objArticle.body
        
        let imageName = objArticle.isFavourite ? Images.Articles.favouriteOn : Images.Articles.favouriteOff
        contentView?.starButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
