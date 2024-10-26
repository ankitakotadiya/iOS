//
//  FilterViewController.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 20/10/24.
//

import UIKit
import Foundation
import Combine

final class FilterViewController: UIViewController {

    private let viewModel: FilterViewModel
    private var cancellable = Set<AnyCancellable>()
    private var rightBarButtonItem: UIBarButtonItem?
    var onTapFilter: (([Filter]) -> Void)?
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = FilterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter"
        navigationController?.navigationBar.tintColor = .black

        setUpView()
        viewModel.createDefaultFilter()
    }
    
    lazy var View: FilterView? = {
        return self.view as? FilterView
    }()
    
    private func setUpView() {
        setUpTableView()
        bindViewModel()
        View?.btnApply.addAction(UIAction { [weak self] _ in
            guard let self = self else {return}
            self.filterButtonTapped()
        }, for: .touchUpInside)
    }
    
    private func setUpTableView() {
        View?.tableView.delegate = self
        View?.tableView.dataSource = self
        
        View?.tableView.estimatedRowHeight = 50
        View?.tableView.rowHeight = UITableView.automaticDimension
        View?.tableView.registerClassWithDefaultIdentifier(FilterTableViewCell.self)
    }
    
    private func setUpNavigationItems() {
        rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(rightBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func filterButtonTapped() {
        onTapFilter?(self.viewModel.selectedFilter)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func bindViewModel() {
        viewModel.$Filters.sink { [weak self] _ in
            self?.updateUI()
        }.store(in: &cancellable)
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.View?.tableView.reloadData()
        }
    }
    
    @objc private func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = nil
        viewModel.clearFilter()
    }
    
    deinit {
        print("FilterViewController Deallocated")
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.Filters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterTableViewCell = tableView.dequeueReusableCellWithIdentifier()
        cell.selectionStyle = .none
        
        if let filterItem = viewModel.Filters?[indexPath.row] {
            cell.configure(for: filterItem)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let filterItem = viewModel.Filters?[indexPath.row] else {return}
        
        let subFilterViewModel = SubFilterViewModel(type: filterItem.title, selectedValues: filterItem.values)
        let subFilterVC = SubFilterViewController(viewModel: subFilterViewModel)
        
        subFilterVC.applySubject.sink { [weak self] (subFilters, type) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.setUpNavigationItems()
            }
            viewModel.setFilter(type: type, subFilters: subFilters)
        }.store(in: &cancellable)
        
        navigationController?.pushViewController(subFilterVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
