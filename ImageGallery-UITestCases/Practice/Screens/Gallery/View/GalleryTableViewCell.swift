//
//  GalleryTableViewCell.swift
//  Practice
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    let imgView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.accessibilityIdentifier = "GalleryImage"
        return imageview
    }()
    
    let descriptionLable: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let View: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemMint, for: .normal)
        button.setTitle("More", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = false
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    private var isExpanded: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupView() {
        contentView._addsubViews(View, imgView, descriptionLable, moreButton)
        moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            View.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            View.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            View.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            View.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            imgView.leadingAnchor.constraint(equalTo: View.leadingAnchor, constant: 5),
            imgView.trailingAnchor.constraint(equalTo: View.trailingAnchor, constant: -5),
            imgView.topAnchor.constraint(equalTo: View.topAnchor, constant: 5),
            imgView.heightAnchor.constraint(equalToConstant: 150),
            
            descriptionLable.leadingAnchor.constraint(equalTo: View.leadingAnchor, constant: 5),
            descriptionLable.trailingAnchor.constraint(equalTo: View.trailingAnchor, constant: -5),
            descriptionLable.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 5),
//            descriptionLable.bottomAnchor.constraint(equalTo: View.bottomAnchor, constant: -5),
            descriptionLable.heightAnchor.constraint(greaterThanOrEqualToConstant: 25),
            
            moreButton.leadingAnchor.constraint(equalTo: View.leadingAnchor, constant: 5),
            moreButton.trailingAnchor.constraint(equalTo: View.trailingAnchor, constant: -5),
            moreButton.bottomAnchor.constraint(equalTo: View.bottomAnchor, constant: -5),
            moreButton.topAnchor.constraint(equalTo: descriptionLable.bottomAnchor, constant: 5),
            moreButton.heightAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    @objc private func moreButtonTapped(_ sender: UIButton) {
        isExpanded.toggle()
        descriptionLable.numberOfLines = isExpanded ? 0 : 1
        moreButton.setTitle(isExpanded ? "Less" : "More", for: .normal)
    }
}

extension GalleryTableViewCell {
    func configure(for gallery: Gallery) {
        imgView.image = UIImage(data: gallery.image)
        descriptionLable.text = gallery.description
        
        if gallery.description.count > 50 {
            moreButton.isHidden = false
            descriptionLable.numberOfLines = isExpanded ? 0 : 1
            moreButton.setTitle(isExpanded ? "Less" : "More", for: .normal)
        } else {
            moreButton.isHidden = true
            descriptionLable.numberOfLines = 0
        }
    }
}
