import Foundation
import UIKit

final class SubtitleCell: UITableViewCell {
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Body.mediumSemiBold
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Body.small
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(mainStackView)
        
        textStackView.dm_addArrangedSubviews(titleLabel, dateLabel)
        mainStackView.dm_addArrangedSubviews(articleImageView, textStackView)
        
        self.activateConstraints()
    }
    
    private func activateConstraints() {
        // Constraints
        NSLayoutConstraint.activate([
            articleImageView.widthAnchor.constraint(equalToConstant: 80),
            articleImageView.heightAnchor.constraint(equalToConstant: 80),
            
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}

extension SubtitleCell: ConfigurableCell  {
    func configure(with model: Article) {
        titleLabel.text = model.headline
        dateLabel.text = model.published?.toString()
        articleImageView.sd_setImage(with: model.imageURL)
    }
}
