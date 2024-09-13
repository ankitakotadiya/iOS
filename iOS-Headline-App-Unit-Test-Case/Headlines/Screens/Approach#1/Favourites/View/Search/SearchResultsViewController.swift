import UIKit

protocol ConfigurableCell {
    associatedtype Item
    func configure(with model: Item)
}

class SearchResultsViewController<Item, Cell: UITableViewCell>: UITableViewController where Cell: ConfigurableCell, Cell.Item == Item {
    
    var articles = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
    }
    
    private func configureTableView() {
        tableView.dm_registerClassWithDefaultIdentifier(cellClass: Cell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func textSizeChanged() {
        tableView.reloadData()
    }
    
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dm_dequeueReusableCellWithDefaultIdentifier()
        
        let article = articles[indexPath.row]
        cell.configure(with: article)
        
        return cell
    }
}
