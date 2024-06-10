//
//  ViewController.swift
//  LoginSignup-TestCase
//
//  Created by Ankita Kotadiya on 10/06/24.
//

import UIKit

class ViewController: UIViewController, Storyboard {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var vm: LoginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let result = self.vm.validateData(email: emailTextField.text, password: passwordTextField.text)
        self.showAlert(title: "Login", message: result.rawValue)
    }
    
}

