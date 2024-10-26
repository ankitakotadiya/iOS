//
//  CollectionReusableView.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 20/10/24.
//

import Foundation
import UIKit

final class CollectionReusableView: UICollectionReusableView {
    
    let sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SORT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.Body.smallSemiBold
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("FILTER", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.Body.smallSemiBold
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 5
        stackview.distribution = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var onFilterTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterButton.addAction(UIAction { [weak self] _ in
            self?.onTapFilter()
        }, for: .touchUpInside)
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func onTapFilter() {
        onFilterTapped?()
    }
    
    private func setUpView() {
        backgroundColor = .white
        stackView.addArrangedSubViews(sortButton, seperatorView, filterButton)
        addSubViews(stackView, seperatorLine)
        
        activateConstraints()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            seperatorView.widthAnchor.constraint(equalToConstant: 0.5),
            
            seperatorLine.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
            seperatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            seperatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            seperatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            seperatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            sortButton.widthAnchor.constraint(equalTo: filterButton.widthAnchor) // Ensure equal widths
        ])
        
    }
}
