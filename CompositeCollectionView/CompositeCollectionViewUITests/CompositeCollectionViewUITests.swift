//
//  CompositeCollectionViewUITests.swift
//  CompositeCollectionViewUITests
//
//  Created by Ankita Kotadiya on 03/11/24.
//

import XCTest

final class CompositeCollectionViewUITests: XCTestCase {

    var app: XCUIApplication!
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ui_loaded() {
        // Product CollectionView Exist
        let navBar = app.navigationBars["Composite Layout"]
        XCTAssertTrue(navBar.exists)
        
        // CollectionView Exists
        let productCollection = app.collectionViews["ProductCollectionView"]
        XCTAssertTrue(productCollection.waitForExistence(timeout: 2.0))
        
        // Test number of sections of collection view
        let header = productCollection.staticTexts["Beauty"]
        XCTAssertTrue(header.exists)

        // Number of sections
        XCTAssertGreaterThan(productCollection.cells.count, 0)
    }
}
