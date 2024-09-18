//
//  MovieCollectionViewCell.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 16/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import UIKit

protocol ConfigurableCell: AnyObject {
    associatedtype Item
    func configure(_ item: Item)
}

final class MovieCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let tagView = TagView()
    
    private let textStackView = UIStackView()
    private let containerStackView = UIStackView()
    
    private let columnSpacing: CGFloat = 10
    private let posterSize = CGSize(width: 144, height: 212)
    var genreManaging: GenreManaging = GenreManager.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        titleLabel.font = UIFont.Body.smallSemiBold
        titleLabel.textColor = UIColor.Text.darkgrey
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        genreLabel.font = UIFont.Body.xSmall
        genreLabel.textColor = UIColor.Text.grey
        genreLabel.textAlignment = .left
        genreLabel.numberOfLines = 0
        
        textStackView.spacing = 2
        textStackView.alignment = .leading
        textStackView.axis = .vertical
        
        containerStackView.spacing = columnSpacing
        containerStackView.alignment = .leading
        containerStackView.axis = .vertical
        containerStackView.translatesAutoresizingMaskIntoConstraints = false

        self.setupViewsHierarchy()
        self.setupConstraints()
    }
    
    func setupViewsHierarchy() {
        textStackView.dm_addArrangedSubviews(titleLabel, genreLabel)
        containerStackView.dm_addArrangedSubviews(imageView, textStackView, tagView)
        contentView.addSubview(containerStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: posterSize.height),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            genreLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
}

extension MovieCollectionViewCell: ConfigurableCell {
    typealias Item = Movie
    func configure(_ item: Item) {
        titleLabel.text = item.title
        
        let genreNames = item.genreIds.compactMap{ self.genreManaging.genreName(for: $0)}
        genreLabel.text = genreNames.joined(separator: " . ")
        tagView.configure(.rating(value: item.voteAverage))
        
        // Set the image (Assuming you have a method to load images)
        if let posterpath = item.posterPath {
            imageView.dm_setImage(posterPath: posterpath)
        }
    }
}
