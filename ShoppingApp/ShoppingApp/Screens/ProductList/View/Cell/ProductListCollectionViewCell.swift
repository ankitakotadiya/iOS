
import UIKit

final class ProductListCollectionViewCell: UICollectionViewCell {
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .white
        return stackView
    }()
    
    let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.isScrollEnabled = true
        scrollview.isDirectionalLockEnabled = true // Lock scroll direction to horizontal
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.isPagingEnabled = true
        scrollview.showsVerticalScrollIndicator = false // No vertical scroll indicator
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.alwaysBounceVertical = false // Disable vertical bounce
        scrollview.alwaysBounceHorizontal = false // Enable horizontal bounce
        return scrollview
    }()
    
    // You can use pagecontrol if you needed
    private let pagContol: UIPageControl = {
        let pagecontrol = UIPageControl()
        pagecontrol.currentPage = 0
        pagecontrol.pageIndicatorTintColor = .lightGray
        pagecontrol.currentPageIndicatorTintColor = .black
        pagecontrol.translatesAutoresizingMaskIntoConstraints = false
        return pagecontrol
    }()
    
    let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.Body.small
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelPrice: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.Body.smallSemiBold
        label.textColor = .black
//        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart")?.withTintColor(.black, renderingMode: .alwaysOriginal) // Default heart image (empty)
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        mainStackView._applyCornerRadius(radius: 8)

        priceStackView.addArrangedSubViews(labelPrice, favButton)
        mainStackView.addArrangedSubViews(scrollView, priceStackView, labelTitle)
        contentView.addSubview(mainStackView)
        
        mainStackView.setCustomSpacing(10, after: imageView)
        mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        activateConstraints()
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            scrollView.heightAnchor.constraint(equalToConstant: 150),
//            labelPrice.heightAnchor.constraint(equalToConstant: 25),
            labelTitle.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    private func setupScrollImages(images: [URL]) {
        // Clear old images
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        // Create image views
        var previousImageView: UIImageView?
        
        for (index, imageURL) in images.enumerated() {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.setImage(from: imageURL)
            scrollView.addSubview(imageView)
            
            // Set constraints for imageView
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                // Setting leading anchor for the first imageView, and trailing for the rest
                imageView.heightAnchor.constraint(equalToConstant: 150),
                imageView.leadingAnchor.constraint(equalTo: previousImageView?.trailingAnchor ?? scrollView.leadingAnchor, constant: 0)
            ])
            
            previousImageView = imageView // Update previousImageView for the next image
        }
        
        // Set the last imageView's trailing anchor
        if let lastImageView = previousImageView {
            lastImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        }
        
        // This line is not needed, as we are using Auto Layout to handle the content size.
//        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(images.count), height: scrollView.frame.height)
    }
}

extension ProductListCollectionViewCell {
    func configure(for product: Product) {
        labelTitle.text = product.title 
        labelPrice.text = String(describing: product.price)
        
        if let imageUrls = product.imgURLs {
            setupScrollImages(images: imageUrls)
        }
    }
}
