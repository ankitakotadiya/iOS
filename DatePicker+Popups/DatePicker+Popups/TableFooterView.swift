//
//  TableFooterView.swift
//  DatePicker+Popups
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import UIKit

class TableFooterView: UIView {

    let loadMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load More...", for: .normal)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(loadMoreButton)
        
        NSLayoutConstraint.activate([
            loadMoreButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            loadMoreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            loadMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            loadMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            loadMoreButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
