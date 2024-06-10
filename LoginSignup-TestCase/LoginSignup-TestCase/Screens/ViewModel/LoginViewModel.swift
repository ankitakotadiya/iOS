//
//  LoginViewModel.swift
//  LoginSignup-TestCase
//
//  Created by Ankita Kotadiya on 10/06/24.
//

import Foundation

final class LoginViewModel {
    
    private let validationHelper: ValidationProtocol
    
    init(validationHeler: ValidationProtocol = ValidateData()) {
        self.validationHelper = validationHeler
    }
    
    func validateData(email: String?, password: String?) -> ValidationError {
        let emailType = validationHelper.validateEmail(email)
        let passwordType = validationHelper.validatePassword(password)
        
        if emailType != .success {
            return emailType
        } else if passwordType != .success {
            return passwordType
        } else {
            return .success
        }
    }
}
