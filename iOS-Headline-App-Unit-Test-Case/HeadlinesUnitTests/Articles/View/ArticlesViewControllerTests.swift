//
//  ArticlesViewControllerTests.swift
//  ArticlesViewModelTests
//
//  Created by Ankita Kotadiya on 06/09/24.
//  Copyright © 2024 Example. All rights reserved.
//

import XCTest
@testable import Headlines

final class ArticlesViewControllerTests: XCTestCase {
    
    var viewModel: MockArticlesViewModel?
    var sut: ViewController?

    override func setUpWithError() throws {
        viewModel = MockArticlesViewModel()
        sut = ViewController(viewModel: viewModel!)
        
    }
    
    func test_loading_stage() {
        _ = sut?.view
        XCTAssertEqual(sut?.title, "Articles")
        XCTAssertNotNil(sut?.contentView)
        XCTAssertNotNil(sut?.contentView?.collectionView)
    }
    
    func test_api_success_response_received() {
        viewModel?.isError = false
        _ = sut?.view
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel?.state.articles.count, 1)
        }
    }
    
    func test_api_error() {
        viewModel?.isError = true
        
        _ = sut?.view
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel?.state, .error("Error"))
        }
    }

    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
    }
}
