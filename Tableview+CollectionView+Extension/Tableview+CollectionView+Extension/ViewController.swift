//
//  ViewController.swift
//  Tableview+CollectionView+Extension
//
//  Created by Ankita Kotadiya on 13/05/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // In just one line of code we can register Tableview/CollectionView Cell
        self.tableView.register(cellType: HomeUITableViewCell.self)
        self.collectionView.register(cellType: HomeCollectionViewCell.self)

    }
}

