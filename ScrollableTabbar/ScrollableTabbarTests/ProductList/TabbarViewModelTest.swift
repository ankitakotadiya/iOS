//
//  ScrollableTabbarTests.swift
//  ScrollableTabbarTests
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import XCTest
@testable import ScrollableTabbar

final class TabbarViewModelTest: XCTestCase {

    var networkManager: MockNetworkManager?
    var viewModel: TabbarViewModel?
    
    override func setUpWithError() throws {
        networkManager = MockNetworkManager()
        viewModel = TabbarViewModel(_networkManager: networkManager!)
    }
    
    func test_getProductList_success() {
        let expectation = expectation(description: "Api response should received")
        
        let cancellable = viewModel?.$products.sink(receiveValue: { product in
            if let product = product {
                XCTAssertEqual(product.count, 1)
                XCTAssertNotNil(product.first)
                XCTAssertEqual(product.first?.title, "Test Product1")
                expectation.fulfill()
            }
        })
        
        viewModel?.getProductList()
        
        wait(for: [expectation], timeout: 1.0)
        cancellable?.cancel()
    }
    
    func test_getProductList_error() {
        networkManager?.isError = true
        viewModel?.getProductList()
        XCTAssertNotNil(viewModel?.errorString)
    }
    
    func test_filterdata_type() {
        viewModel?.getProductList()
        viewModel?.filterdata(type: "NEW IN DATE")
        XCTAssertEqual(viewModel?.products?.count, 1)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        networkManager = nil
    }

}
