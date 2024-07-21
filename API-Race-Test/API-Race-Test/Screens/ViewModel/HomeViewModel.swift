//
//  HomeViewModel.swift
//  API-Race-Test
//
//  Created by Ankita Kotadiya on 20/07/24.
//

import Foundation
import Combine

class HomeViewModel {
    let apiService: NetworkManagerProtocol
    @Published var usersData: [User] = []
    @Published var errors: NetworkError?
    
    init(apiService: NetworkManagerProtocol = NetworkManager()) {
        self.apiService = apiService
    }
    
    func fetCombineAPIData() {
        self.apiService.callCombineAPI(url: API.baseURL, queryParams: [:], bodyParams: [:], method: .get, type: User.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errors = error
                    print(error.localizedDescription)
                }
            } receiveValue: { users in
                self.usersData = users
            }
            .store(in: &Cancellable.shared.set)
    }
    
    func fetchCombineAnyPublisher() {
        self.apiService.callCombineAnyPublisher(url: API.baseURL, queryParams: [:], bodyParams: [:], method: .get, type: User.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.errors = error
            }
        } receiveValue: { users in
            self.usersData = users
        }.store(in: &Cancellable.shared.set)
    }
    
    func fetchDataFromNetwork() async {
        
        do {
            let users = try await self.apiService.callAsyncAPI(url: API.baseURL, queryParams: [:], bodyParams: [:], method: .get, type: User.self)
            self.usersData = users
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchTraditionalApiData() {
        self.apiService.traditionalApiCall(url: API.baseURL, queryparams: [:], bodyParams: [:], method: .get, type: User.self) { completion in
            switch completion {
            case .failure(let error):
                self.errors = error
            case .success(let users):
                self.usersData = users
            }
        }
    }
}
