//
//  HomeViewModel.swift
//  API-Combine
//
//  Created by Ankita Kotadiya on 13/05/24.
//

import Foundation
import Combine


protocol HomeViewModelProtocol: AnyObject { // If you do not want to expose type
    associatedtype T: Decodable
    typealias Handler<T> = (Result<T, DataError>) -> Void
    func fetchHomeViewData(completionHandler: @escaping Handler<T>)
}

class HomeViewModel: HomeViewModelProtocol {
    
    
    typealias T = [HomeModel] // you can define type
    private let apiService: NetworkManagerProtocol
    
    private var cancellable = Set<AnyCancellable>()
    var users: [HomeModel] = []
    
    var queryParams: [String: String] {
        return ["page":"1", "limit":"10"]
    }
    
    init (apiService: NetworkManagerProtocol = NetworkManager()) {
        self.apiService = apiService
    }
    
    func fetchHomeViewData(completionHandler: @escaping Handler<T>)  {
        apiService.fetchData(url: .home, queryParams: queryParams, method: .GET, bodyParams: [:], type: HomeModel.self).sink { completion in
            
            switch completion {
            case .finished:
                break
            case .failure(let error):
                completionHandler(.failure(error))
            }
        } receiveValue: { users in
            completionHandler(.success(users))
            
        }.store(in: &self.cancellable)
    }
}
