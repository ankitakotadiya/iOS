//
//  Validation.swift
//  LoginSignup-TestCaseTests
//
//  Created by Ankita Kotadiya on 10/06/24.
//

import XCTest
@testable import LoginSignup_TestCase

final class Validation: XCTestCase {
    
    var validator: ValidateData?
    
    override func setUpWithError() throws {
        validator = ValidateData()
    }
    
    override func tearDownWithError() throws {
        validator = nil
        
    }
    
    
    func testValidEmail_withEmptyEmail() {
        let result = validator?.validateEmail("")
        XCTAssertTrue(result == .emptyEmail, "Please enter an Email.")
    }
    
    func testValidEmail_withInvalidEmail() {
        let result = validator?.validateEmail("ankitakotadia")
        XCTAssertEqual(result, .invalidEmail, "Email Is Invalid.")
    }
    
    func testValidEmail_withValidEmail() {
        let result = validator?.validateEmail("ankitakotadia@gmail.com")
        XCTAssertEqual(result, .success, "Email Is Valid.")
    }
    
    func testValidPassword_withEmptyPassword() {
        let result = validator?.validatePassword("")
        XCTAssertEqual(result, .emptyPassword)
    }
    
    func testValidPassword_withWeakPassword() {
        let result = validator?.validatePassword("123")
        XCTAssertEqual(result, .weak, "Weak Password.")
    }
    
    func testValidPassword_withSuccessPassword() {
        let result = validator?.validatePassword("Ankita@123")
        XCTAssertEqual(result, .success, "Success")
    }
    
    func testValidPassword_withValidPassword() {
        let result = validator?.validatePassword("Ankita123")
        XCTAssertEqual(result, .invalidPassword, "Invalid Password")
    }

    
}
