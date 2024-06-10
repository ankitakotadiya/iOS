//
//  ValidateData.swift
//  LoginSignup-TestCase
//
//  Created by Ankita Kotadiya on 10/06/24.
//

import Foundation


enum ValidationError: String {
    case emptyEmail = "Please enter an Email."
    case emptyPassword = "Please enter Password."
    case invalidEmail = "Please enter valid Email."
    case invalidPassword = "Please enter valid Password."
    case weak = "Please enter at least 6 charaters long Password."
    case success = "Login Success."
}


protocol ValidationProtocol {
    func validateEmail(_ email: String?) -> ValidationError
    func validatePassword(_ password: String?) -> ValidationError
}

class ValidateData: ValidationProtocol {
    
    
    func validatePassword(_ password: String?) -> ValidationError {
        
        guard let password, !password.isEmpty else {
            return .emptyPassword
        }
        
        if password.count < 6{
            return .weak
        }
        
        if !isValidPassword(password: password) {
            return .invalidPassword
        }
        
        return .success
    }
    
    
    func validateEmail(_ email: String?) -> ValidationError {
        
        guard let email, !email.isEmpty  else {
            return .emptyEmail
        }
        if !isValidEmailFormat(email) {
            return .invalidEmail
        }
        
        return .success
    }
    
    
    
    private func isValidEmailFormat(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$&*]).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
