//
//  ViewController.swift
//  API-Race-Test
//
//  Created by Ankita Kotadiya on 20/07/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var HVM: HomeViewModel?
    private var api: NetworkManagerProtocol?
    private let apiService = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = NetworkManager()
        self.HVM = HomeViewModel(apiService: self.api!)
        
//        self.callCombineAPI()
//        self.dummyAPICall()
        
        self.HVM?.$usersData.sink(receiveValue: { users in
            if users.count > 0 {
                print(users)
            }
        }).store(in: &Cancellable.shared.set)
        
        Task {
            await self.parallelAPICall()
        }
        
        self.concurrentTasks()
    }
    
    func callCombineAPI() {
        self.HVM?.fetchTraditionalApiData()
    }
    
    func serialAPICall() async {
        do {
            let startTime = Date()
            
            let user1 = try await self.api?.callAsyncAPI(url: API.baseURL, queryParams: [:], bodyParams: [:], method: .get, type: User.self)
            
            let user2 = try await self.api?.callAsyncAPI(url: API.baseURL, queryParams: [:], bodyParams: [:], method: .get, type: User.self)
            let users = [user1,user2]
            print(users)
            let endTime = Date()
            let totalTime = String(format: "%.2f", endTime.timeIntervalSince(startTime))
            print(totalTime)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func parallelAPICall() async {
        do {
            let startTime = Date()
            
            async let user1 = self.api?.callAsyncAPI(url: API.baseURL, queryParams: [:], bodyParams: [:], method: .get, type: User.self)
            
            async let user2 = self.api?.callAsyncAPI(url: API.baseURL, queryParams: [:], bodyParams: [:], method: .get, type: User.self)
            let users = try await [user1, user2]
            let endTime = Date()
            let totalTime = String(format: "%.2f", endTime.timeIntervalSince(startTime))
            print(totalTime)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func dummyAPICall() {
        self.apiService.dummyApiCall(url: API.baseURL, queryParams: [:], bodyParams: [:], method: .get, type: User.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { users in
            print(users)
        }
        .store(in: &Cancellable.shared.set)
    }
    
    func concurrentTasks() {
        //It will perform concurrently
        let queue1 = DispatchQueue(label: "Queue1")
//        DispatchQueue.global().async {
//            self.performTask1() // if async task submitted then it will work concurrently
//            self.performTask2() //if serial/sync submitted then serially
//        }
        
        //It executes the tasks serially if submit concurrent tasks then executes concurrently
        queue1.async {
            queue1.async {
                self.performTask1()
            }
            queue1.async {
                self.performTask2()
            }
        }
    }
    
    private func performTask1() {
        for i in 0...30 {
            print("---->\(i)")
        }
        
//        sleep(UInt32(3.0))
//        DispatchQueue.global().asyncAfter(deadline: .now()+3) {
//            print("Task1 Completed")
//        }
    }
    
    private func performTask2() {
        for i in 31...40 {
            print("----X\(i)")
        }
//        sleep(UInt32(1.0))
//        DispatchQueue.global().asyncAfter(deadline: .now()+2) {
//            print("Task2 Completed")
//        }
    }
}

