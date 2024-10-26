//
//  FilterView.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 21/10/24.
//

import Foundation
import UIKit

class FilterView: UIView {
    let tableView: UITableView = {
        let tblview = UITableView()
        tblview.backgroundColor = .white
        tblview.translatesAutoresizingMaskIntoConstraints = false
        return tblview
    }()
    
    let btnApply: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.Body.medium
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        backgroundColor = .white
        addSubViews(tableView, btnApply)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: btnApply.topAnchor),
            
            btnApply.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            btnApply.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            btnApply.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            btnApply.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
