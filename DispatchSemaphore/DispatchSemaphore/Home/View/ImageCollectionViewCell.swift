//
//  ImageCollectionViewCell.swift
//  DispatchSemaphore
//
//  Created by Ankita Kotadiya on 16/05/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(for data: Data) {
//        self.imgView.image = UIImage(data: data)
    }

}
