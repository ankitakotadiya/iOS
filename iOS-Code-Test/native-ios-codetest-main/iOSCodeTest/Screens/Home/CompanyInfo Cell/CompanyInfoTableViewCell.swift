//
// Copyright © 2024 ASOS. All rights reserved.
//

import UIKit

final class CompanyInfoTableViewCell: UITableViewCell {
    
    private let View: CompanyInfoView = CompanyInfoView.instantiate()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        contentView.addSubview(View)
        View.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            View.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            View.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            View.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            View.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        ])
    }
}

extension CompanyInfoTableViewCell {
    func configure(with data: CompanyInfoView.ViewData) {
        View.configure(with: data)
    }
}

