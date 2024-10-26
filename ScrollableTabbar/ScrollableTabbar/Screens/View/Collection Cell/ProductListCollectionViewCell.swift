//
//  ProductListCollectionViewCell.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import UIKit

final class ProductListCollectionViewCell: UICollectionViewCell {
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let mainStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 5
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    let priceStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 5
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    let favButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        priceStackView._addArrangedSubViews(titleLable, priceLabel)
        mainStackView._addArrangedSubViews(imageView, priceStackView, descriptionLabel)
        contentView._addSubViews(view, mainStackView, favButton)
        view._applyCornerRadius(radius: 8.0)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5),
            
            favButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            favButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            favButton.widthAnchor.constraint(equalToConstant: 30),
            favButton.heightAnchor.constraint(equalToConstant: 30),
            
            imageView.heightAnchor.constraint(equalToConstant: 150),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
}

extension ProductListCollectionViewCell {
    func configure(for product: Product) {
        titleLable.text = product.title
        descriptionLabel.text = product.description
        priceLabel.text = "\(product.price)"
        
        imageView.image = nil
        if let imageURL = product.imgURLs?.first {
            imageView.setImage(from: imageURL)
        }
    }
}
