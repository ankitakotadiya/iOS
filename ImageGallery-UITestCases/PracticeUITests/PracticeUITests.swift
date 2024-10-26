//
//  PracticeUITests.swift
//  PracticeUITests
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import XCTest
@testable import Practice
import UniformTypeIdentifiers

final class PracticeUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func test_SelectImages() {
        app.launch()
        
        // Navigation bar
        let navigationBar = app.navigationBars["Image Gallery"]
        XCTAssertTrue(navigationBar.exists)
        
        // Image Gallery Button
        let galleryButton = app.buttons["Select Images"]
        XCTAssertTrue(galleryButton.exists)
        galleryButton.tap()
        
        // Image Picker Presented
        let picker = app.otherElements["Photos"]
        XCTAssertTrue(picker.waitForExistence(timeout: 5))
        XCTAssertTrue(picker.exists)
        
        let firstImage = picker.images.firstMatch
        XCTAssertTrue(firstImage.exists)
        firstImage.tap()
        
        let addButton = app.buttons["Add"]
        addButton.tap()
        
        let tableView = app.tables["ImageTableView"]
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        XCTAssertTrue(tableView.exists)
        
        let firstRow = tableView.cells.firstMatch
        let rowImage = firstRow.images["GalleryImage"]
        XCTAssertTrue(rowImage.exists)
    }
    

    override func tearDownWithError() throws {
        app = nil
    }

}
