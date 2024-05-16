//
//  ViewController.swift
//  DispatchSemaphore
//
//  Created by Ankita Kotadiya on 16/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let vm = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        
        self.vm.$imgData.sink { data in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.store(in: &self.vm.cancellable)
        
        self.vm.downloadImageData()
        
    }
    
    func configureCollectionView() {
        self.collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell {
            cell.configure(for: self.vm.imgData[indexPath.item])
        }
        return UICollectionViewCell()
    }
}

