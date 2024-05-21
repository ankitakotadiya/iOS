//
//  DispatchBarrier.swift
//
//  Created by Ankita Kotadiya on 21/05/24.
//

import Foundation


class BankAccount {
    private var balance: Double
    private let queue = DispatchQueue(label: "com.bankaccount.queue", attributes: .concurrent)
    
    init(balance: Double) {
        self.balance = balance
    }
    
    func deposit(amount: Double) {
        queue.async(flags: .barrier) {
            self.balance += amount
            print("Deposited \(amount), new balance is \(self.balance)")
        }
    }
    
    func withdraw(amount: Double) {
        queue.async(flags: .barrier) {
            guard self.balance >= amount else {
                print("Insufficient funds to withdraw \(amount), current balance is \(self.balance)")
                return
            }
            self.balance -= amount
            print("Withdrew \(amount), new balance is \(self.balance)")
        }
    }
    
    func getBalance() {
        queue.async {
            print("Current balance is \(self.balance)")
        }
    }
}

