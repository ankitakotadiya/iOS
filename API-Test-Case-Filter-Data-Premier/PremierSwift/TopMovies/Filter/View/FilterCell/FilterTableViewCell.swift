//
//  FilterTableViewCell.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 15/09/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import UIKit

protocol FilterCellDelegate: AnyObject {
    func didTapSelectButton(_ selectedItem: FilterItems?, in section: Titles?)
}

class FilterTableViewCell: UITableViewCell {
    
    weak var delegate: FilterCellDelegate?
    var currentItem: FilterItems?
    var currentType: Titles?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.Body.small
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonSelect: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCornerRadius(forIndexPath indexPath: IndexPath, inTableView tableView: UITableView) {
        let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1
        containerView.layer.maskedCorners = []
        seperatorView.backgroundColor = .lightGray
        
        if indexPath.row == 0 && indexPath.row == lastRow {
            containerView.layer.cornerRadius = 10
            containerView.layer.maskedCorners = [.layerMaxXMinYCorner,
                                        .layerMinXMinYCorner,
                                        .layerMinXMaxYCorner,
                                        .layerMaxXMaxYCorner]
            seperatorView.backgroundColor = .white
        } else if indexPath.row == 0 {
            containerView.layer.cornerRadius = 10
            containerView.layer.maskedCorners = [.layerMaxXMinYCorner,
                                        .layerMinXMinYCorner]
        } else if indexPath.row == lastRow {
            containerView.layer.cornerRadius = 10
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner,
                                        .layerMaxXMaxYCorner]
            seperatorView.backgroundColor = .white
        }
    }
    
    private func setUpView() {
        stackView.dm_addArrangedSubviews(labelTitle, buttonSelect)
        contentView.dm_addSubviews(containerView, stackView, seperatorView)
        buttonSelect.addTarget(self, action: #selector(buttonSelectionTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: seperatorView.topAnchor, constant: -10),
            
            seperatorView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            buttonSelect.widthAnchor.constraint(equalToConstant: 25),
            buttonSelect.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        // Adding shadow to the cell
        contentView.backgroundColor = UIColor.Background.lightGrey
    }
    
    @objc func buttonSelectionTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        configureButtonSelection(sender.isSelected)
        delegate?.didTapSelectButton(currentItem, in: currentType)
    }
    
    func configureButtonSelection(_ isSelected: Bool) {
        if isSelected {
            buttonSelect.setImage(UIImage(systemName: "checkmark")?.withTintColor(UIColor.Brand.popsicle40, renderingMode: .alwaysOriginal), for: .normal)
            buttonSelect.layer.borderColor = UIColor.Brand.popsicle40.cgColor
        } else {
            buttonSelect.setImage(nil, for: .normal)
            buttonSelect.layer.borderColor = UIColor.lightGray.cgColor
            buttonSelect.backgroundColor = .white
        }
    }
    
    func configureCell(with item: FilterItems?, in section: Titles?) {
        currentItem = item
        currentType = section
        labelTitle.text = item?.name
        configureButtonSelection(item?.isSelected ?? false)
    }
}
