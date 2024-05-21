//
//  ViewController.swift
//  API-Combine
//
//  Created by Ankita Kotadiya on 13/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var homeVM = HomeViewModel()
    private var users:[HomeModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAccountData()
    }
    
        
    private func getAccountData() {
        let account = BankAccount(balance: 1000.0)

        // Simulate concurrent access
        DispatchQueue.global().async {
            account.getBalance()
        }
        
        // Deposit and Withdraw api called once response received from one api till that time another api will wait.
        DispatchQueue.global().async {
            account.deposit(amount: 200.0)
        }

        DispatchQueue.global().async {
            account.withdraw(amount: 150.0)
        }

        // You will receive Async response with updated account balancr
        DispatchQueue.global().async {
            account.getBalance()
        }
    }
}

