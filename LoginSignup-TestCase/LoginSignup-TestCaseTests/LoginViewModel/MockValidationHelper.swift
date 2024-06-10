//
//  MockValidationHelper.swift
//  LoginSignup-TestCaseTests
//
//  Created by Ankita Kotadiya on 10/06/24.
//

import Foundation
import XCTest
@testable import LoginSignup_TestCase


class MockValidationHelper: ValidationProtocol {
    var emailResult: ValidationError = .success
    var passwordResult: ValidationError = .success
    
    func validateEmail(_ email: String?) -> LoginSignup_TestCase.ValidationError {
        return emailResult
    }
    
    func validatePassword(_ password: String?) -> LoginSignup_TestCase.ValidationError {
        return passwordResult
    }
}
