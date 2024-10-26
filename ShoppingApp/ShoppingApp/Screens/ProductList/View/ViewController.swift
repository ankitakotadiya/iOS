//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    
    private let viewModel: ProductListViewModel
    private var cancellable = Set<AnyCancellable>()
    private let headerHeight: CGFloat = 50
    private var previousOffset: CGFloat = 0
    private var isHeaderVisible = true // Track whether the header is visible
    private let scrollThreshold: CGFloat = 10 // Threshold for triggering animation
    
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = ProductView()
    }
    
    lazy var View: ProductView? = {
        return self.view as? ProductView
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product List"
        setUpCollectionView()
        bindViewModel()
        DispatchQueue.global().async {
            self.viewModel.getProductList()
        }
    }
    
    private func bindViewModel() {
        viewModel.$state.sink { [weak self] _ in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.updateUI()
            }
        }.store(in: &self.cancellable)
    }
    
    private func updateUI() {
        switch viewModel.state {
        case .loading:
            self.showIndicator()
        case .loaded(_):
            self.hideIndicator()
            View?.collectionView.reloadData()
        case .eror(let error):
            self.hideIndicator()
            handleError(error)
        }
    }
    
    private func setUpCollectionView() {
        previousOffset = View?.collectionView.contentOffset.y ?? 0
        View?.collectionView.dataSource = self
        View?.collectionView.delegate = self
        
        View?.collectionView.registerClassWithDefaultIdentifier(cellClass: ProductListCollectionViewCell.self)
        View?.collectionView.registerHeaderClassWithReusableIdentifier(cellClass: CollectionReusableView.self)
    }
    
    private func handleError(_ message: String) {
        self.displayAlert(title: "Products", message: message, actionTitle: "Okay!")
    }
    
    private func navigateToFilterVC() {
        let filterVC = FilterViewController(viewModel: FilterViewModel(savedFilter: viewModel.filters))
        filterVC.onTapFilter = { [weak self] filters in
            guard let self = self else {return}
            viewModel.filterProducts(filters: filters)
        }
        let nav = UINavigationController(rootViewController: filterVC)
        navigationController?.present(nav, animated: true)
        
//        let dummy = DummyViewController()
//        navigationController?.pushViewController(dummy, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductListCollectionViewCell = collectionView.dequeueReusableCellWithDefaultIdentifier(indexPath)
        
        let product = viewModel.state.products[indexPath.item]
        cell.configure(for: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: CollectionReusableView = collectionView.dequeReusableSupplementryHeader(indexPath)
        
        headerView.onFilterTapped = { [weak self] in
            guard let self = self else {return}
            self.navigateToFilterVC()
        }
        
        return headerView
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-5, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        
        // Calculate the difference in scrolling
        let offsetDifference = currentOffset - previousOffset
        
        // Check if scrolling down and if the offset difference exceeds the threshold
        if offsetDifference > scrollThreshold && isHeaderVisible {
            if let layout = View?.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionHeadersPinToVisibleBounds = false
            }
            isHeaderVisible = false
        }
        
        // Check if scrolling up and if the offset difference exceeds the threshold
        if offsetDifference < -scrollThreshold && !isHeaderVisible {
            if let layout = View?.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionHeadersPinToVisibleBounds = true
            }
            isHeaderVisible = true
        }
        
        // Update the previous offset for the next comparison
        previousOffset = currentOffset
    }
}

extension ViewController {
    final class ProductView: UIView {
        let collectionView: UICollectionView
        
        override init(frame: CGRect) {
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 15
            layout.sectionHeadersPinToVisibleBounds = true
            
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            super.init(frame: frame)
            
            setUpCollectionView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUpCollectionView() {
            backgroundColor = .white
            collectionView.backgroundColor = UIColor.Brand.extraLightGray
            addSubview(collectionView)
            
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
    }
}

