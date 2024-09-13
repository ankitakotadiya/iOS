import UIKit

protocol ArticleCollectionViewCellDelegate: AnyObject {
    func addToFavourite(for article: Article)
    func didRequestToOpenFavoritesList()
}

final class ArticlesCollectionViewCell: UICollectionViewCell {
    
    private let articlesView: ArticlesContentView = ArticlesContentView()
    weak var delegate: ArticleCollectionViewCellDelegate?
    
    var article: Article? {
        didSet {
            configureCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        contentView.addSubview(articlesView)
        articlesView.translatesAutoresizingMaskIntoConstraints = false
        
        articlesView.starButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        articlesView.favouriteButton.addTarget(self, action: #selector(favouritesButtonTapped(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            articlesView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articlesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            articlesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articlesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
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
extension ArticlesCollectionViewCell {
    func configureCell() {
        guard let objArticle = article else {return}
        self.articlesView.imageView.sd_setImage(with: objArticle.imageURL)
        self.articlesView.titleLabel.text = objArticle.headline
        self.articlesView.bodyLabel.text = objArticle.body
        
        let imageName = objArticle.isFavourite ? Images.Articles.favouriteOn : Images.Articles.favouriteOff
        self.articlesView.starButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
