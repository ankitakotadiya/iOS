//
// Copyright © 2022 ASOS. All rights reserved.
//

import Foundation

protocol HomeViewModelPresenter {
	func updateContent()
}

final class HomeViewModel {
	private struct State {
		var company: Company?
		var launches: [Launch] = []
		var rockets: [Rocket] = []
	}

	private var companyFetcher: CompanyFetcher
	private let launchesFetcher: LaunchesFetcher
	private let rocketsFetcher: RocketsFetcher 
	private let dateFormatter: DateFormatting

	var presenter: HomeViewModelPresenter?
    
    init (
        _companyService: CompanyFetcher = CompanyService(),
        _launchService: LaunchesFetcher = LaunchesService(),
        _rocketService: RocketsFetcher = RocketsService(),
        _dateFormatter: DateFormatting = DefaultDateFormatter()
    ) {
        self.companyFetcher = _companyService
        self.launchesFetcher = _launchService
        self.rocketsFetcher = _rocketService
        self.dateFormatter = _dateFormatter
    }

	private var state = State() {
		didSet {
			presenter?.updateContent()
		}
	}

    @MainActor
    func load() async {
//        let startDate = Date()
        async let companyFetcher = companyFetcher.fetchCompany()
        async let launchesFetcher = launchesFetcher.fetchLaunches()
        async let rocketsFetcher = rocketsFetcher.fetchRockets()
        
        do {
            self.state = try await State(company: companyFetcher.get(), launches: launchesFetcher.get(), rockets: rocketsFetcher.get())
//            let endDate = Date()
//            print("Time required to call apis: \(endDate.timeIntervalSince(startDate)) secs.")
        } catch {
            print(error.localizedDescription)
        }
        
        //                companyFetcher.fetchCompany { [weak self] companyResult in
        //                    self?.launchesFetcher.fetchLaunches { launchesResult in
        //                        self?.rocketsFetcher.fetchRockets { rocketsResult in
        //                            self?.state = State(
        //                                company: try? companyResult.get(),
        //                                launches: (try? launchesResult.get()) ?? [],
        //                                rockets: (try? rocketsResult.get()) ?? []
        //                            )
        //                            let endDate = Date()
        //                            print("Time required to call apis: \(endDate.timeIntervalSince(startDate)) secs.")
        //                        }
        //                    }
        //                }
    }

	var companyInfoViewData: CompanyInfoView.ViewData? {
		guard let company = state.company else {
			return nil
		}
		return CompanyInfoView.ViewData(
			companyInfo: """
				\(company.name) was founded by \(company.founder) in \(company.founded). It has \
				\(company.employees) employees, \(company.launchSites) launch sites, and is valued \
				at USD \(company.valuation)
				"""
		)
	}

	var launchesViewData: [LaunchSummaryView.ViewData] {
        let rocketDictionary = Dictionary(uniqueKeysWithValues: state.rockets.map({($0.id, $0)}))
		return state.launches.map { launch in
//            var launchRocket: Rocket? = state.rockets.first(where: {$0.id == launch.rocketID})
//			for rocket in state.rockets {
//				if rocket.id == launch.rocketID {
//					launchRocket = rocket
//				}
//			}
            let launchRocket: Rocket? = rocketDictionary[launch.rocketID]
			let date = Date(timeIntervalSince1970: launch.timestamp)
			let dateString = dateFormatter.dateAndTime(from: date)
			return LaunchSummaryView.ViewData(
				patchImageURL: launch.links.patch.small,
				missionName: launch.name,
				date: dateString,
                rocketInfo: launchRocket?.name ?? "",
                success: launch.success ?? false
			)
		}
	}
}
