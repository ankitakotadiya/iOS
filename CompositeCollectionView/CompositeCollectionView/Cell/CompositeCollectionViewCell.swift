//
//  CompositeCollectionViewCell.swift
//  CompositeCollectionView
//
//  Created by Ankita Kotadiya on 03/11/24.
//

import UIKit

final class CompositeCollectionViewCell: UICollectionViewCell {
    let View: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imgeView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let rightStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.spacing = 5
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
//        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .justified
//        label.backgroundColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 10
//        stackview.backgroundColor = .brown
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    let priceLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        rightStackView._addArrangedSubviews(titleLable, descriptionLable, priceStackView)
        priceStackView._addArrangedSubviews(priceLable, likeButton)
        contentView._addsubViews(View,imgeView, rightStackView)
        View.backgroundColor = UIColor.Brand.extraLightGray
        
        NSLayoutConstraint.activate([
            View.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            View.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            View.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            View.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            imgeView.centerYAnchor.constraint(equalTo: View.centerYAnchor),
            imgeView.leadingAnchor.constraint(equalTo: View.leadingAnchor),
            imgeView.widthAnchor.constraint(equalToConstant: 100),
            imgeView.heightAnchor.constraint(equalTo: imgeView.widthAnchor, multiplier: 1),
            
            rightStackView.leadingAnchor.constraint(equalTo: imgeView.trailingAnchor, constant: 5),
            rightStackView.topAnchor.constraint(equalTo: View.topAnchor, constant: 5),
            rightStackView.trailingAnchor.constraint(equalTo: View.trailingAnchor, constant: -5),
            rightStackView.bottomAnchor.constraint(equalTo: View.bottomAnchor, constant: -5),
        ])
    }
}

extension CompositeCollectionViewCell {
    func configure(with item: Product) {
        imgeView.image = nil
        if let imageURL = item.imgURLs?.first {
            imgeView.setImage(from: imageURL)
        }
        titleLable.text = item.title
        descriptionLable.text = item.description
        priceLable.text = "Price: \(item.price)"
    }
}
