//
// Copyright © 2022 ASOS. All rights reserved.
//

import XCTest
@testable import iOSCodeTest

class HomeViewModelTests: XCTestCase {
	let presenter = HomeViewModelPresenterMock()
    let dateFormatter = MockDateFormatter()

	private func makeViewModel() -> HomeViewModel {
        let viewModel = HomeViewModel(
            _companyService: MockCompanyService(),
            _launchService: MockLaunchService(),
            _rocketService: MockRocketService(),
            _dateFormatter: dateFormatter
        )
		viewModel.presenter = presenter
		return viewModel
	}
    
    private var launchExpecteddata: [LaunchSummaryView.ViewData] {
        let rocketDictionary = [Rocket.testValue.id: Rocket.testValue]
        let launches = [Launch.testValue]
        
        return launches.map { launch in
            let launchRocket: Rocket? = rocketDictionary[launch.rocketID]
            let date = Date(timeIntervalSince1970: launch.timestamp)
            let dateString = dateFormatter.dateAndTime(from: date)
            return LaunchSummaryView.ViewData(
                patchImageURL: launch.links.patch.small,
                missionName: launch.name,
                date: dateString,
                rocketInfo: launchRocket?.name ?? "",
                success: launch.success ?? false,
                webcast: launch.links.webcast,
                wikipedia: launch.links.wikipedia
            )
        }
    }
    
    private var companyExpecteddata: CompanyInfoView.ViewData {
        return CompanyInfoView.ViewData(
            companyInfo: """
                \(Company.testValue.name) was founded by \(Company.testValue.founder) in \(Company.testValue.founded). It has \
                \(Company.testValue.employees) employees, \(Company.testValue.launchSites) launch sites, and is valued \
                at USD \(Company.testValue.valuation)
                """
        )
    }

    func testCompanyInfo() async {
		// Given
		let viewModel = makeViewModel()

		// When
        await viewModel.load()
        await fulfillment(of: [presenter.updateContentExpectation], timeout: 5)

		// Then
		XCTAssertEqual(viewModel.companyInfoViewData, companyExpecteddata)
	}
    
    func testLaunchData() async {
        let viewModel = makeViewModel()
        
        await viewModel.load()
        await fulfillment(of: [presenter.updateContentExpectation], timeout: 2)
        
        XCTAssertEqual(viewModel.launchesViewData, launchExpecteddata)
    }
}

// MARK: - Test Types

class HomeViewModelPresenterMock: HomeViewModelPresenter {
    
	let updateContentExpectation = XCTestExpectation(description: "updateContent")
	func updateContent() {
		updateContentExpectation.fulfill()
	}
}
