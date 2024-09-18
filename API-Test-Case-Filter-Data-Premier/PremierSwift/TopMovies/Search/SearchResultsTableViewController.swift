//
//  SearchResultsTableViewController.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 17/09/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    var items = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableview()
    }
    
    private func setUpTableview() {
        self.title = LocalizedString(key: "movies.title")
        tableView.dm_registerClassWithDefaultIdentifier(cellClass: MovieCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier()
        
        let movie = items[indexPath.row]
        cell.configure(movie)
        
        return cell
    }
}
