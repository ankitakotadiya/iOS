import UIKit
import SDWebImage

class ArticlesContentView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView() // Replace with your image name
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.Heading.large
        titleLabel.textColor = UIColor.Background.main
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    lazy var imageContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Body.medium
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Images.Articles.favouriteOff), for: .normal)
        button.tintColor = .black
        button.clipsToBounds = true
        button.contentHorizontalAlignment = .leading
//        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Favourites", for: .normal)
        button.setTitleColor(UIColor.Brand.popsicle40, for: .normal)
        button.contentHorizontalAlignment = .trailing
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    //    private let descriptionTextView: UITextView = {
    //        let textView = UITextView()
    //        textView.isScrollEnabled = true
    //        textView.isEditable = false
    //        textView.translatesAutoresizingMaskIntoConstraints = false
    //        return textView
    //    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        
        imageContainerView.addSubview(imageView)
        imageContainerView.addSubview(titleLabel)
        
        buttonStackView.dm_addArrangedSubviews(starButton, favouriteButton)
        
        mainStackView.dm_addArrangedSubviews(imageContainerView, bodyLabel, buttonStackView)
        mainStackView.setCustomSpacing(25, after: bodyLabel)
        
        self.setUpViewHierarchy()
        self.activateConstraints()
    }
    
    private func setUpViewHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
    }
    
    private func activateConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            imageContainerView.heightAnchor.constraint(equalToConstant: 200),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -16),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: imageContainerView.topAnchor, constant: 16),
            
//            mainStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            
//            bodyLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 20),
//            bodyLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20),
//            
//            buttonStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 20),
//            buttonStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20)
        ])
    }
}


