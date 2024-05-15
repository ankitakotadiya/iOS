//
//  ViewController.swift
//  DispatchGroup
//
//  Created by Ankita Kotadiya on 15/05/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.$user
            .sink { user in
                self.nameLabel.text = user?.name
                self.addressLabel.text = user?.Address
            }.store(in: &self.viewModel.cancellable)
        
        self.viewModel.$userDetails
            .sink { userDetail in
                if let imageUrlString = userDetail?.image, let imageUrl = URL(string: imageUrlString) {
                    Task {
                        do {
                            if let imgData = try? await self.downloadImage(from: imageUrl) {
                                self.imgView.image = UIImage(data: imgData)
                            }
                        }
                    }
                }
            }.store(in: &self.viewModel.cancellable)
        
        DispatchQueue.global().async { [weak self] in
            self?.viewModel.fetchUserData()
        }
        
    }
    
    private func downloadImage(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }

}

