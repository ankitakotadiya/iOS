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
        self.homeVM.fetchHomeViewData { completion in
            switch completion {
            case .success(let responseData):
                self.users = responseData
                print(self.users)
            case .failure(let dataError):
                print(dataError.localizedDescription)
            }
        }
    }
}

