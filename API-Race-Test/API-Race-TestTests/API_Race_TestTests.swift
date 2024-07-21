//
//  API_Race_TestTests.swift
//  API-Race-TestTests
//
//  Created by Ankita Kotadiya on 20/07/24.
//

import XCTest
import Combine
@testable import API_Race_Test

final class API_Race_TestTests: XCTestCase {
    
    var apiservice: NetworkMockService?
    var VM: HomeViewModel?
    var cancellable = Set<AnyCancellable>()

    override func setUpWithError() throws {
        self.apiservice = NetworkMockService()
        self.VM = HomeViewModel(apiService: self.apiservice!)
    }

    override func tearDownWithError() throws {
        self.apiservice = nil
        self.VM = nil
    }
    
    func test_fetch_data_success() async {
        let expectation = self.expectation(description: "Fetch Data")
        
        self.VM?.$usersData.sink(receiveValue: { users in
            if !users.isEmpty {
                XCTAssertEqual(users[0].name, "Ankita")
                XCTAssertEqual(users[1].name, "Zow")
                XCTAssertEqual(users[2].name, "Priya")
                XCTAssertEqual(users[3].name, "Zubair")
                expectation.fulfill()
            }
        }).store(in: &self.cancellable)
        
        await self.VM?.fetchDataFromNetwork()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_fetch_data_failure() async {
        self.apiservice?.error = .invalidData
        self.apiservice?.isError = true
        
        let expectation = self.expectation(description: "Fetch Data")
        await self.VM?.fetchDataFromNetwork()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_combine_api_success() {
        
        let expectation = self.expectation(description: "Combine Call")
        self.VM?.fetCombineAPIData()
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_combine_api_failure() {
        
        let expectation = self.expectation(description: "Combine Call Fail")

        self.apiservice?.error = .invalidData
        self.apiservice?.isError = true
        
        self.VM?.$errors.sink(receiveValue: { error in
            if (error != nil) {
                XCTAssertEqual(error, .invalidData)
                expectation.fulfill()
            }
        }).store(in: &self.cancellable)
        
        self.VM?.fetCombineAPIData()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetch_AnyPublisher_data_success() {
        let expectation = self.expectation(description: "Fetch Data")
        
        self.VM?.$usersData.sink(receiveValue: { users in
            if !users.isEmpty {
                XCTAssertEqual(users[0].name, "Ankita")
                XCTAssertEqual(users[1].name, "Zow")
                XCTAssertEqual(users[2].name, "Priya")
                XCTAssertEqual(users[3].name, "Zubair")
                expectation.fulfill()
            }
        }).store(in: &self.cancellable)
        
        self.VM?.fetchCombineAnyPublisher()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_traditional_api_success() {
        let expectation = self.expectation(description: "API Data")
        
        self.VM?.$usersData.sink(receiveValue: { users in
            if users.count > 0 {
                XCTAssertEqual(users[0].name, "Ankita")
                expectation.fulfill()
            }
        })
        .store(in: &self.cancellable)
        self.VM?.fetchTraditionalApiData()
        wait(for: [expectation],timeout: 1.0)
    }
}
