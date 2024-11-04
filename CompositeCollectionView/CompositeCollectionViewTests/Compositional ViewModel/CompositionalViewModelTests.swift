//
//  CompositionalViewModelTests.swift
//  CompositeCollectionViewTests
//
//  Created by Ankita Kotadiya on 04/11/24.
//

import Foundation
@testable import CompositeCollectionView
import XCTest

final class CompositionalViewModelTests: XCTestCase {
    
    var viewModel: CompositeViewModel?
    var networkManager: MockNetworkManager?
    
    override func setUpWithError() throws {
        networkManager = MockNetworkManager()
        viewModel = CompositeViewModel(networkManager: networkManager!)
    }
    
    override func tearDownWithError() throws {
        networkManager = nil
        viewModel = nil
    }
    
    func test_product_list_response_received() async {
        networkManager?.iserror = false
        
        await viewModel?.load()
        
        let cancellable = viewModel?.$sections.sink(receiveValue: { section in
            XCTAssertTrue(section.count > 0)
            XCTAssertEqual(section.first?.title, .beauty)
        })
        
        cancellable?.cancel()
    }
    
    func test_product_list_failure() async {
        networkManager?.iserror = true
        
        await viewModel?.load()
        
        let cancellable = viewModel?.$sections.sink(receiveValue: { section in
            XCTAssertTrue(section.count == 0)
        })
        
        cancellable?.cancel()
    }
}
