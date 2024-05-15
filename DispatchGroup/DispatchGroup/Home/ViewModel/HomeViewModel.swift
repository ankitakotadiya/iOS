//
//  HomeViewModel.swift
//  DispatchGroup
//
//  Created by Ankita Kotadiya on 15/05/24.
//

import Foundation
import Combine

protocol HomeViewModelProtocol: AnyObject {
    func fetchUserData()
}

class HomeViewModel: HomeViewModelProtocol {
    @Published var user: User?
    @Published var userDetails: UserDetails?
    var posts: [Posts] = []
    var queryParams: [String: String] {
        return ["page":"1", "limit":"10"]
    }
    
    private let apiService: NetworkManagerProtocol
    var cancellable = Set<AnyCancellable>()
    
    init(apiService: NetworkManagerProtocol = NetworkManager()) {
        self.apiService = apiService
    }
    
    func fetchUserData() {
        let dispatchgroup = DispatchGroup()
        
        dispatchgroup.enter()
        self.apiService.fetchData(url: .home, queryParams: self.queryParams, method: .GET, bodyParams: [:], type: Posts.self).sink { completion in
            switch completion {
                
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { responseData in
            self.user = User(name: "Ankita", Address: "London")
            print("First API Response Received")
            dispatchgroup.leave()
        }.store(in: &self.cancellable)
        
        dispatchgroup.wait() //Please don't use wait function in main thread otherwise it will block current execution and create deadlock situation
        //        dispatchgroup.notify(queue: .main) { //Another way is to use notify function when first API call is done
        print("Second API Called")
        dispatchgroup.enter()
        self.apiService.fetchData(url: .home, queryParams: self.queryParams, method: .GET, bodyParams: [:], type: Posts.self).sink { completion in
            switch completion {
                
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { responseData in
            print(responseData)
            self.userDetails = UserDetails(image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg")
            print("Second API Response Received")
            dispatchgroup.leave()
        }.store(in: &self.cancellable)
        //        }
    }
}
