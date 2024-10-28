//
//  ScrollableTabbarUITests.swift
//  ScrollableTabbarUITests
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import XCTest

final class ScrollableTabbarUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()
        
    }

    
    func test_tabItemHasDisplayed_and_selecteable() {
        // Navigation Title
        let navigationBar = app.navigationBars["Products"]
        XCTAssertTrue(navigationBar.exists)
        
        let tabCollectionView = app.collectionViews["TabCollectionView"]
        XCTAssertTrue(tabCollectionView.exists)
        XCTAssertEqual(tabCollectionView.cells.count, 4)
                
        let beauty = tabCollectionView.cells.staticTexts["BEAUTY"]
        beauty.tap()
        let selectedCell = tabCollectionView.cells.element(boundBy: 0)
        XCTAssertTrue(selectedCell.isSelected)
        
        let productCollection = app.collectionViews["ProductCollectionView"]
        XCTAssertTrue(productCollection.exists)
        
        let cellTitle = productCollection.cells.staticTexts["Test Product1"]
        XCTAssertTrue(cellTitle.exists)
    }

    override func tearDownWithError() throws {
        app = nil
    }

}
