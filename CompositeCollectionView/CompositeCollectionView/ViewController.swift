//
//  ViewController.swift
//  CompositeCollectionView
//
//  Created by Ankita Kotadiya on 03/11/24.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var cancellable = Set<AnyCancellable>()
    var viewModel: CompositeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Composite Layout"
        configureCollectionView()
        bindViewModel()
        Task {
            await viewModel.load()
        }
    }
    
    private func createCompositeCollectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else {return nil}
            
            switch sectionIndex {
            case 0:
                return self.createCarouselSection(
                    isVertical: true,
                    groupWidth: 0.90,
                    groupHeight: 250,
                    itemHeight: 1/2,
                    isGrid: true
                )
            case 1:
                return self.createCarouselSection(
                    isVertical: false,
                    groupWidth: 0.99,
                    groupHeight: 200,
                    itemHeight: 1,
                    isGrid: true
                )
            case 2:
                return self.createCarouselSection(
                    isVertical: true,
                    groupWidth: 1,
                    groupHeight: 150,
                    itemHeight: 1,
                    isGrid: false
                )
            default:
                return self.createCarouselSection(
                    isVertical: true,
                    groupWidth: 0.90,
                    groupHeight: 250,
                    itemHeight: 1/2,
                    isGrid: true
                )
            }
        }
    }
    
    private func createCarouselSection(
        isVertical: Bool,
        groupWidth: CGFloat,
        groupHeight: CGFloat,
        itemHeight: CGFloat,
        isGrid: Bool
    ) -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidth), heightDimension: .absolute(groupHeight))
        let group = isVertical ? NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item]) : NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        if isGrid {
            section.orthogonalScrollingBehavior = .groupPaging
        }
        
        // Header
        section.boundarySupplementaryItems = [createHeader(height: 50)]
        
        return section
    }
    
    private func createHeader(height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    private func configureCollectionView() {
        // Set Layout
        collectionView.collectionViewLayout = createCompositeCollectionLayout()
        collectionView.accessibilityIdentifier = "ProductCollectionView"
        
        collectionView._registerCellWithIdentifier(CompositeCollectionViewCell.self)
        collectionView._registerHeaderViewwithIdentifier(HeaderView.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.$sections.sink { [weak self] _ in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.store(in: &cancellable)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CompositeCollectionViewCell = collectionView._dequeReusableCellWithIdentifier(indexPath)
        cell.configure(with: viewModel.sections[indexPath.section].products[indexPath.item])
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: HeaderView = collectionView._dequeReusableHeaderWithIdentifier(indexPath)
        
        headerView.configure(with: viewModel.sections[indexPath.section].title.rawValue)
        
        return headerView
    }
}

