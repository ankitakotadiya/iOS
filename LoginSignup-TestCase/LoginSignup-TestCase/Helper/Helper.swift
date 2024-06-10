//
//  Helper.swift
//  SignupLogin
//
//  Created by Ankita Kotadiya on 28/07/23.
//

import Foundation
import UIKit

struct APIs {
    static let baseURL = ""
}

extension String {
    func className(for classType:AnyClass) -> String {
        return String(describing: classType)
    }
    
    func toData(using encoding: String.Encoding = .utf8) -> Data {
        return data(using: encoding)!
    }
}

extension UIViewController {
    
    func showAlert(title: String?, message: String?) {
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okaction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertcontroller.addAction(okaction)
        present(alertcontroller, animated: true, completion: nil)
        
    }
}
