//
//  SubFilterViewController.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 20/10/24.
//

import UIKit
import Combine

final class SubFilterViewController: UIViewController {

    private let viewModel: SubFilterViewModel
    private var cancellable = Set<AnyCancellable>()
    var applySubject = PassthroughSubject<([SubFilter], Titles), Never>()
    private var rightBarButtonItem: UIBarButtonItem?
    
    init(viewModel: SubFilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = FilterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var View: FilterView? = {
        return self.view as? FilterView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.type.rawValue
        setUpNavigationItems()
        configureTableView()
        buttonApplyClicked()
        viewModel.createSubFilter()
        bindViewModel()
    }
    
    private func configureTableView() {
        View?.tableView.dataSource = self
        View?.tableView.delegate = self
        
        View?.tableView.estimatedRowHeight = 50
        View?.tableView.rowHeight = UITableView.automaticDimension
        
        View?.tableView.registerClassWithDefaultIdentifier(FilterTableViewCell.self)
    }
    
    private func buttonApplyClicked() {
        View?.btnApply.addAction(UIAction { [weak self] _ in
            self?.applyFilter()
        }, for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.$subFilters.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.View?.tableView.reloadData()
            }
        }.store(in: &cancellable)
    }
    
    private func toggleTitle() {
        if viewModel.selectedCount >= 1 {
            rightBarButtonItem?.title = "Clear"
        } else {
            rightBarButtonItem?.title = "All"
        }
    }
    
    private func setUpNavigationItems() {
        rightBarButtonItem = UIBarButtonItem(title: "All", style: .plain, target: self, action: #selector(rightBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        
        if rightBarButtonItem?.title == "All" {
            viewModel.allFilterSelected()
        } else {
            viewModel.clearFilter()
        }
        
        let title: String = rightBarButtonItem?.title == "All" ? "Clear" : "All"
        rightBarButtonItem?.title = title
    }
    
    private func applyFilter() {
        applySubject.send((viewModel.selectedFilterItems, viewModel.type))
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("SubFilterViewController Deallocated")
    }
}

extension SubFilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.subFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterTableViewCell = tableView.dequeueReusableCellWithIdentifier()
        cell.selectionStyle = .none
        
        let item = viewModel.subFilters[indexPath.row]
        
        if item.isSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.configure(for: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.subFilters[indexPath.row].isSelected {
            viewModel.subFilters[indexPath.row].isSelected = false
            viewModel.selectedCount -= 1
        } else {
            viewModel.subFilters[indexPath.row].isSelected = true
            viewModel.selectedCount += 1
        }
        
        toggleTitle()
    }
}
