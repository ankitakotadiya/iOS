//
//  LoginViewModelTestCases.swift
//  LoginSignup-TestCaseTests
//
//  Created by Ankita Kotadiya on 10/06/24.
//

import XCTest
@testable import LoginSignup_TestCase

final class LoginViewModelTestCases: XCTestCase {
    
    var viewModel: LoginViewModel?
    var mockValidationHelper: MockValidationHelper?
    
    override func setUpWithError() throws {
        mockValidationHelper = MockValidationHelper()
        viewModel = LoginViewModel(validationHeler: mockValidationHelper!)
    }
    
    override func tearDownWithError() throws {
        mockValidationHelper = nil
        viewModel = nil
    }
    
    func testValidateData_withValidCredentials_returnsSuccess() {
        mockValidationHelper?.emailResult = .success
        mockValidationHelper?.passwordResult = .success
        
        let result = viewModel?.validateData(email: "test@example.com", password: "Password!")
        
        XCTAssertEqual(result, .success)
    }
    
    func testValidateData_withInvalidEmail_returnsEmailError() {
        mockValidationHelper?.emailResult = .invalidEmail
        mockValidationHelper?.passwordResult = .success
        
        let result = viewModel?.validateData(email: "invalidEmail", password: "Password!")
        
        XCTAssertEqual(result, .invalidEmail)
    }
    
    func testValidateData_withInvalidPassword_returnsPasswordError() {
        mockValidationHelper?.emailResult = .success
        mockValidationHelper?.passwordResult = .weak
        
        let result = viewModel?.validateData(email: "test@example.com", password: "123")
        
        XCTAssertEqual(result, .weak)
    }
    
    func testValidateData_withEmptyEmail_returnsEmailEmptyError() {
        mockValidationHelper?.emailResult = .emptyEmail
        mockValidationHelper?.passwordResult = .success
        
        let result = viewModel?.validateData(email: "", password: "Password!")
        
        XCTAssertEqual(result, .emptyEmail)
    }
    
    func testValidateData_withEmptyPassword_returnsPasswordEmptyError() {
        mockValidationHelper?.emailResult = .success
        mockValidationHelper?.passwordResult = .emptyPassword
        
        let result = viewModel?.validateData(email: "test@example.com", password: "")
        
        XCTAssertEqual(result, .emptyPassword)
    }
    
}
