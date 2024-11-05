//
// Copyright © 2022 ASOS. All rights reserved.
//

import XCTest

class iOSCodeTestUITests: XCTestCase {
	func testCompanyInfo() throws {
		// Given: App Launch
		let app = XCUIApplication()
		app.launch()
		// Then: Can see company info table
        let tableView = app.tables["CompanyTableView"]
        XCTAssertTrue(tableView.exists)
//        
//        // Then: Can see first tableview cell
        let companyInfoCell = app.cells.firstMatch
        let titleLabel = companyInfoCell.staticTexts["companyInfo"]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 3))
                        
    }

	func testOpenLaunchArticle() throws {
		// Given: App is launched
		let app = XCUIApplication()
		app.launch()
		// When: Tap a launch cell and view its article
		app.cells.element(boundBy: 1).tap()
		app.buttons["Read Article"].tap()
		// Then: Article opened in Safari
		let safariApplication = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
		_ = safariApplication.wait(for: .runningForeground, timeout: 1)
	}
}
