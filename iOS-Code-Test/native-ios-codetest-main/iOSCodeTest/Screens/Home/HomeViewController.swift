//
// Copyright © 2022 ASOS. All rights reserved.
//

import UIKit

final class HomeViewController: UITableViewController {
	fileprivate enum Section {
		case companyInformation(CompanyInfoView.ViewData)
		case launches([LaunchSummaryView.ViewData])
	}

	private struct State {
		var sections: [Section] = []
	}

	// MARK: Properties

	private var state = State() {
		didSet {
			tableView.reloadData()
		}
	}

	private let viewModel = HomeViewModel()

	// MARK: Loading

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "SpaceX"
        tableView.accessibilityIdentifier = "CompanyTableView"
		viewModel.presenter = self
        configureTableView()
        Task {
            await viewModel.load()
        }
//        viewModel.load()
	}
    
    private func configureTableView() {
        tableView._registerTableViewCellWithIdentifier(CompanyInfoTableViewCell.self)
    }

	// MARK: Table View Sources

	override func numberOfSections(in tableView: UITableView) -> Int {
		state.sections.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		state.sections[section].numberOfRows
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch state.sections[indexPath.section] {
		case .companyInformation(let viewData):
            
            guard let cell: CompanyInfoTableViewCell = tableView._dequeueReusableCellwithIdentifier() else {
                return UITableViewCell()
            }
            cell.configure(with: viewData)
            return cell
            
//			let cell = UITableViewCell(style: .default, reuseIdentifier: "companyInformation")
//			cell.selectionStyle = .none
//			let companyInfoView = CompanyInfoView.instantiate()
//			companyInfoView.configure(with: viewData)
//			companyInfoView.translatesAutoresizingMaskIntoConstraints = false
//			cell.contentView.addSubview(companyInfoView)
//			companyInfoView.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor).isActive = true
//			companyInfoView.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
//			companyInfoView.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
//			companyInfoView.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
//			return cell
		case .launches(let launches):
			let viewData = launches[indexPath.row]
			let cell = UITableViewCell(style: .default, reuseIdentifier: "launch\(indexPath.row)")
			cell.selectionStyle = .none
			let launchSummaryView = LaunchSummaryView.instantiate()
			launchSummaryView.configure(with: viewData)
			launchSummaryView.translatesAutoresizingMaskIntoConstraints = false
			cell.contentView.addSubview(launchSummaryView)
			launchSummaryView.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor).isActive = true
			launchSummaryView.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
			launchSummaryView.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
			launchSummaryView.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
			return cell
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		state.sections[section].sectionTitle
	}

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch state.sections[indexPath.section] {
        case .companyInformation(_):
            break
        case .launches(let launchData):
            let launch = launchData[indexPath.row]
            guard let url = launch.wikipedia else {return}
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: - HomeViewModelPresenter

extension HomeViewController: HomeViewModelPresenter {
	func updateContent() {
		let companyInfoSection = viewModel.companyInfoViewData.map({ Section.companyInformation($0) })
		let launchesSection = Section.launches(viewModel.launchesViewData)
		let sections = [companyInfoSection, launchesSection].compactMap({ $0 })
		state = State(sections: sections)
	}
}

// MARK: - Section Helpers

extension HomeViewController.Section {
	var sectionTitle: String {
		switch self {
		case .companyInformation:
			return "Company"
		case .launches:
			return "Launches"
		}
	}

	var numberOfRows: Int {
		switch self {
		case .companyInformation:
			return 1
		case .launches(let launchesViewData):
			return launchesViewData.count
		}
	}
}
