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
        self.getHomeData()
    }
    
    private func getHomeData() {
        self.homeVM.fetchHomeViewData()
        print("Both API Called", self.homeVM.users.count)
    }
}

