//
//  ViewAllMoviesViewController.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 12/09/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import UIKit

final class ViewAllMoviesViewController: UIViewController {

    private let viewModel: ViewAllViewModel
    private let tableView: UITableView = UITableView()
    
    init(viewModel: ViewAllViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(target: self, action: #selector(didTapBack(_:)))
        self.title = viewModel.initialMovie.title
        setUpViews()
        setUpTableView()
        updateFromviewModel()
        bindViewModel()
        
        DispatchQueue.global().async {
            self.viewModel.fetchSimilarMovie()
        }
    }
    
    private func setUpViews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.dm_registerClassWithDefaultIdentifier(cellClass: MovieCell.self)
    }
    
    private func bindViewModel() {
        viewModel.updateFromState = { [weak self] in
            DispatchQueue.main.async {
                self?.updateFromviewModel()
            }
        }
    }
    
    private func updateFromviewModel() {
        let state = viewModel.state
        switch state {
        case .loading:
            self.showIndicator()
            
        case .loaded(_):
            self.hideIndicator()
            self.tableView.reloadData()
            
        case .error:
            self.hideIndicator()
            print("Error Displayed!")
        }
    }
    
    func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        footerView.backgroundColor = .white
        
        let viewAllButton: UIButton = UIButton(type: .system)
        viewAllButton.setTitle("View All", for: .normal)
        viewAllButton.backgroundColor = UIColor.Brand.popsicle40
        viewAllButton.titleLabel?.font = UIFont.Body.small
        viewAllButton.setTitleColor(UIColor.Text.white, for: .normal)
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.addTarget(self, action: #selector(viewAllTapped(_:)), for: .touchUpInside)
        footerView.addSubview(viewAllButton)
        
        NSLayoutConstraint.activate([
            viewAllButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            viewAllButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            viewAllButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        return footerView
    }
    
    @objc func viewAllTapped(_ sender: UIButton) {
        let vc = ViewAllMoviesViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapBack(_ sender: UIBarButtonItem) {
        viewModel.currentPage = 1
        navigationController?.popViewController(animated: true)
    }
}

extension ViewAllMoviesViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            if self.tableView.tableFooterView == nil {
                self.tableView.tableFooterView = createFooterView()
            }
//            if viewModel.totalPage > viewModel.state.movie?.count ?? 0 {
////                viewModel.fetchSimilarMovie()
//            }
        }
    }
}

extension ViewAllMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.movie?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier()
        
        if let movie = viewModel.state.movie?[indexPath.row] {
            cell.configure(movie)
        }
        return cell
    }
}

extension ViewAllMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
