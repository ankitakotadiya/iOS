//
//  FilterTableViewCell.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 20/10/24.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 10
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    let lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.Body.medium
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblDescription: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.Body.medium
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUpView() {
        stackView.addArrangedSubViews(lblTitle, lblDescription)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
}

extension FilterTableViewCell {
    func configure(for filter: Filter) {
        lblTitle.text = filter.title.rawValue
        lblDescription.text = filter.values.map({$0.title}).joined(separator: ", ")
    }
    
    func configure(for subFilter: SubFilter) {
        lblTitle.text = subFilter.title
    }
}
