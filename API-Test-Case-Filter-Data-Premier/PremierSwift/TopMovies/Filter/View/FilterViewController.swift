//
//  FilterViewController.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 11/09/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import UIKit
import Combine

protocol FilterVCDelegate: AnyObject {
    func setSelectedGenres(_ genres: [Section])
}

class FilterViewController: UIViewController {

    private let viewModel: FilterViewModel
    private var cancellable = Set<AnyCancellable>()
    weak var delegate: FilterVCDelegate?
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = FilterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Filter"
        self.navigationController?.presentationController?.delegate = self

        self.configureTableview()
        self.setButtonTarget()
        self.bindViewModel()
        self.viewModel.getGeneres()
    }
    
    private func configureTableview() {
        contentView?.tableView.dataSource = self
        contentView?.tableView.delegate = self
        contentView?.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        
        contentView?.tableView.rowHeight = UITableView.automaticDimension
        contentView?.tableView.estimatedRowHeight = 45
        
        contentView?.tableView.dm_registerClassWithDefaultIdentifier(cellClass: FilterTableViewCell.self)
    }
        
    private lazy var contentView: FilterView? = {
        return self.view as? FilterView
    }()
    
    private func bindViewModel() {
        viewModel.$sections.sink { [weak self] _ in
            self?.contentView?.tableView.reloadData()
        }.store(in: &cancellable)
    }
    
    private func setButtonTarget() {
        contentView?.clearAllButton.addTarget(self, action: #selector(hideShowClearAllButton(_:)), for: .touchUpInside)
        contentView?.applyFilter.addTarget(self, action: #selector(applyFilter(_:)), for: .touchUpInside)
    }
    
    @objc private func hideShowClearAllButton(_ sender: UIButton) {
        viewModel.selectedGenres = []
        UIView.animate(withDuration: 0.3) {
            self.contentView?.clearAllButton.isHidden = true
        }
        viewModel.clearAllFilter()
        self.contentView?.tableView.reloadData()
    }
    
    @objc private func applyFilter(_ sender: UIButton) {
        let selectedFilter = viewModel.applyFilters()
        delegate?.setSelectedGenres(selectedFilter)
        dismiss(animated: true)
    }
    
    deinit {
        print("Filter Deallocated")
    }
}

extension FilterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections?[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterTableViewCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier()
        let item = viewModel.sections?[indexPath.section].items[indexPath.row]
        
        cell.configureCell(with: item, in: viewModel.sections?[indexPath.section].title)
        cell.delegate = self
        cell.setCornerRadius(forIndexPath: indexPath, inTableView: tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: SectionHeaderView = SectionHeaderView()
        
        if let title = viewModel.sections?[section].title {
            headerView.configureView(for: title.rawValue)
        }
        return headerView
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension FilterViewController: FilterCellDelegate {
    func didTapSelectButton(_ selectedItem: FilterItems?, in section: Titles?) {
        guard let item = selectedItem, let section = section else { return }
        viewModel.toggleSection(for: item, in: section)
    }
}

extension FilterViewController {
    private class FilterView: UIView {
        
        let bottomView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 5)
            view.layer.shadowOpacity = 0.2
            view.layer.shadowRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let clearAllButton: UIButton = {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.Brand.popsicle40.cgColor
            button.setTitleColor(UIColor.Brand.popsicle40, for: .normal)
            button.setTitle("Clear All", for: .normal)
            return button
        }()
        
        let applyFilter: UIButton = {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 8
            button.backgroundColor = UIColor.Brand.popsicle40
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitle("Apply Filter", for: .normal)
            return button
        }()
        
        let containerStackview: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.distribution = .fillEqually
            return stackView
        }()
        
        let tableView: UITableView = {
            let tableview = UITableView(frame: .zero, style: .grouped)
            tableview.backgroundColor = UIColor.Background.lightGrey
            tableview.separatorStyle = .none
            return tableview
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUpViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setUpViews() {
            containerStackview.dm_addArrangedSubviews(clearAllButton, applyFilter)
            bottomView.addSubview(containerStackview)
            self.dm_addSubviews(tableView,bottomView)
            
            backgroundColor = UIColor.Background.lightGrey
            activateConstraints()
        }
        
        private func activateConstraints() {
            tableView.translatesAutoresizingMaskIntoConstraints = false
            bottomView.translatesAutoresizingMaskIntoConstraints = false
            applyFilter.translatesAutoresizingMaskIntoConstraints = false
            clearAllButton.translatesAutoresizingMaskIntoConstraints = false
            containerStackview.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
                
                bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
                bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
                bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
                bottomView.heightAnchor.constraint(equalToConstant: 100),
                
                containerStackview.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
                containerStackview.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
                containerStackview.topAnchor.constraint(equalTo: bottomView.topAnchor,constant: 10),
                containerStackview.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor),
                
            ])
        }
    }
}

extension FilterViewController: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//        delegate?.setSelectedGenres(viewModel.selectedGenres)
    }
}
