//
//  SectionHeaderView.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 15/09/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Background.lightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.Heading.small
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(headerView)
        headerView.addSubview(labelTitle)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            labelTitle.topAnchor.constraint(equalTo: headerView.topAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30),
            labelTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            labelTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
    }
    
    func configureView(for title: String) {
        labelTitle.text = title
    }
}
