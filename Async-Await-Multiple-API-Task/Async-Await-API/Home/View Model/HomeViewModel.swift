//
//  HomeViewModel.swift
//  API-Combine
//
//  Created by Ankita Kotadiya on 13/05/24.
//

import Foundation
import Combine


protocol HomeViewModelProtocol: AnyObject { // If you do not want to expose type
//    associatedtype T: Decodable
//    typealias Handler<T> = (Result<T, DataError>) -> Void
    func fetchHomeViewData()
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
    
    func fetchHomeViewData()  {
        
        // If you have dependency on each other and want to execute serially in async fashion then submit api call in same task otherwise submit on different task
        Task {
            do {
                let data = try await apiService.fetchAsyncData(url: .home, queryParams: self.queryParams, method: .GET, bodyParams: [:], type: HomeModel.self)
                users.append(contentsOf: data)
                
            } catch {
                if let dataError = error as? DataError {
                    print(dataError.localizedDescription)
                }
            }
            
            print("First API Response Received",self.users.count)
            
            do {
                let data = try await apiService.fetchAsyncData(url: .home, queryParams: self.queryParams, method: .GET, bodyParams: [:], type: HomeModel.self)
                users.append(contentsOf: data)
                
            } catch {
                if let dataError = error as? DataError {
                    print(dataError.localizedDescription)
                }
            }
            
            print("Second API Response Received",self.users.count)
        }
        
        Task {
            //API call 1
        }
        
        Task {
            // API call 2
        }
        
    }
}
