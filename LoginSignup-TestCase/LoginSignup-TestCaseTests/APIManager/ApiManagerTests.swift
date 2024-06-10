//
//  ApiManagerTests.swift
//  LoginSignup-TestCaseTests
//
//  Created by Ankita Kotadiya on 10/06/24.
//

import XCTest

@testable import LoginSignup_TestCase
import Combine

class ApiManagerTests: XCTestCase {
    var apiManager: ApiManager?
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        
        // Setup the mock URL protocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockAPIManager.self]
        let mockSession = URLSession(configuration: configuration)
        
        // Inject the mock session into ApiManager
        apiManager = ApiManager(session: mockSession)
        cancellables = []
    }

    override func tearDownWithError() throws {
        apiManager = nil
        cancellables = nil
    }

    func testGetData_Success() {
        // Setup mock response
        let jsonData = """
        [{"id": 1, "name": "John Doe"}]
        """.data(using: .utf8)!
        
        MockAPIManager.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            return (response, jsonData)
        }

        // Test getData
        let expectation = self.expectation(description: "getData")
        apiManager?.getData(endPoint: .users, method: .GET, headers: [:], parameters: [:])
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, got failure: \(error)")
                }
            }, receiveValue: { (result: [User]) in // Specify the type of result as [User]
                XCTAssertEqual(result.first?.name, "John Doe")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetData_Failure() {
        // Setup mock response
        MockAPIManager.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil)!
            return (response, Data())
        }

        // Test getData
        let expectation = self.expectation(description: "getData")
        apiManager?.getData(endPoint: .users, method: .GET, headers: [:], parameters: [:])
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
            }, receiveValue: { (result: [User]) in
                XCTFail("Expected failure, got success: \(result)")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testUploadData_Success() {
        // Setup mock response
        let jsonData = """
        [{"id": 1, "name": "John Doe"}]
        """.data(using: .utf8)!

        MockAPIManager.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            return (response, jsonData)
        }

        // Test uploadData
        let expectation = self.expectation(description: "uploadData")
        apiManager?.uploadData(endPoint: .users, method: .POST, headers: [:], parameters: [:], imageParameters: [:])
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, got failure: \(error)")
                }
            }, receiveValue: { (result: [User]) in
                XCTAssertEqual(result.first?.name, "John Doe")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }

    // Additional test cases for failure scenarios and edge cases can be added similarly
}

