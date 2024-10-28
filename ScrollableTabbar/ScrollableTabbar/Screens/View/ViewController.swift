//
//  ViewController.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import UIKit
import Combine

@MainActor
final class ViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = .white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.accessibilityIdentifier = "TabCollectionView"
        return collectionview
    }()
    
    private let shoppingCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical

        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = UIColor.Brand.extraLightGray
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.accessibilityIdentifier = "ProductCollectionView"
        return collectionview
    }()
    
    private let viewModel: TabbarViewModel
    private var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: TabbarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        setupView()
        bindViewModel()
//        DispatchQueue.global().async {
//            self.viewModel.getProductList()
//        }
        Task {
            await viewModel.getProductList()
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(shoppingCollection)
//        view.addSubview(underLine)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            
            shoppingCollection.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            shoppingCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoppingCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoppingCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
                
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView._registerCollectionViewClassWithIdentifier(TabCollectionViewCell.self)
        
        shoppingCollection.dataSource = self
        shoppingCollection.delegate = self
        shoppingCollection._registerCollectionViewClassWithIdentifier(ProductListCollectionViewCell.self)
    }
    
    private func bindViewModel() {
        viewModel.$products.sink { [weak self] _ in
            self?.updateUI()
        }.store(in: &cancellable)
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.shoppingCollection.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.collectionView ? viewModel.tabItems.count : viewModel.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell: TabCollectionViewCell = collectionView._dequeueReusableCellWithIdentifier(indexPath)
            
            let isSelected = indexPath == selectedIndexPath
            cell.configure(for: viewModel.tabItems[indexPath.item], isSelected: isSelected)
            
            return cell
        } else {
            let cell: ProductListCollectionViewCell = collectionView._dequeueReusableCellWithIdentifier(indexPath)
            
            if let product = viewModel.products?[indexPath.item] {
                cell.configure(for: product)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Deselect the previous item
        if collectionView == self.collectionView {
            if let previousSelectedCell = collectionView.cellForItem(at: selectedIndexPath) as? TabCollectionViewCell {
                previousSelectedCell.configure(for: viewModel.tabItems[selectedIndexPath.item], isSelected: false)
            }
            
            // Update the selected index
            selectedIndexPath = indexPath
            
            // Select the new cell
            if let selectedCell = collectionView.cellForItem(at: indexPath) as? TabCollectionViewCell {
                selectedCell.configure(for: viewModel.tabItems[indexPath.item], isSelected: true)
                collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
                viewModel.filterdata(type: viewModel.tabItems[indexPath.item])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            let title = viewModel.tabItems[indexPath.item]
            
            let font = UIFont.systemFont(ofSize: 16.0)
            
            let size = title.boundingRect(
                with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 50),  // Maximum width, fixed height
                options: .usesLineFragmentOrigin,                                 // Calculate multiline if needed
                attributes: [NSAttributedString.Key.font: font],                  // Font used for the text
                context: nil
            ).size
            
            let textWidth = ceil(size.width) + 16
            return CGSize(width: textWidth, height: 50)
        } else {
            return CGSize(width: collectionView.frame.width, height: 225)
        }
    }
}

