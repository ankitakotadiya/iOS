//
//  SimilarMovieView.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 16/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation
import UIKit

// I have created this class in a way that can be used across the app.
protocol MovieDataSourceProtocol: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    associatedtype Item
    func updateMovies(_ movies: [Item])
}

final class SimilarMovieView<Item, Cell: UICollectionViewCell>: UIView, MovieDataSourceProtocol where Cell: ConfigurableCell, Cell.Item == Item {
    // MARK: - Properties
    private let collectionView: UICollectionView
    var items: [Item] = []
    private let layoutSize: CGSize
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        layoutSize = CGSize(width: 144, height: 302)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .white
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dm_registerClassWithDefaultIdentifier(cellClass: Cell.self)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func updateMovies(_ movies: [Item]) {
        self.items = movies
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dm_dequeueReusableCellWithDefaultIdentifier(indexPath)
        let movie = items[indexPath.item]
        cell.configure(movie)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: layoutSize.width, height: layoutSize.height) // Adjust size if needed
    }
}
