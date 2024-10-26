//
//  TabCollectionViewCell.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import UIKit

final class TabCollectionViewCell: UICollectionViewCell {
    
    let lblTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemTeal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(lblTitle)
        contentView.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lblTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            lineView.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 5),
            lineView.heightAnchor.constraint(equalToConstant: 2.0)
        ])
    }
}

extension TabCollectionViewCell {
    
    func configure(for title: String, isSelected: Bool) {
        lblTitle.text = title
        lblTitle.textColor = isSelected ? .systemTeal : .black
        
        UIView.animate(withDuration: 0.2) {
            self.lineView.backgroundColor = isSelected ? .systemTeal : .white
        }
    }
}
