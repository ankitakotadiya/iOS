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
    
    
//    typealias T = [HomeModel] // you can define type
    private let apiService: NetworkManagerProtocol
    
    private var cancellable = Set<AnyCancellable>()
    var users: [HomeModel] = []
    
    var queryParams: [String: String] {
        return ["page":"1", "limit":"10"]
    }
    
    init (apiService: NetworkManagerProtocol = NetworkManager()) {
        self.apiService = apiService
    }
    
    func fetchHomeViewData(completionHandler: @escaping (Result<[HomeModel], DataError>) -> Void)  {
        
        Task {
            do {
                let data = try await apiService.fetchAsyncData(url: .home, queryParams: self.queryParams, method: .GET, bodyParams: [:], type: HomeModel.self)
                completionHandler(.success(data))
                
            } catch {
                if let dataError = error as? DataError {
                    completionHandler(.failure(dataError))
                }
            }
        }
    }
}
