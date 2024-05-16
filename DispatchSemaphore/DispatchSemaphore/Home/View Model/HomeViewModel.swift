//
//  HomeViewModel.swift
//  DispatchSemaphore
//
//  Created by Ankita Kotadiya on 16/05/24.
//

import Foundation
import Combine

class HomeViewModel {
    
    let apiService: NetworkManagerProtocol
    
    init(apiservice: NetworkManagerProtocol = NetworkManager()) {
        self.apiService = apiservice
    }
    
    var cancellable = Set<AnyCancellable>()
    @Published var imgData: [Data] = []
    private let semaphore = DispatchSemaphore(value: 5)
    let downloadQueue = DispatchQueue(label: "com.example.imageDownload", attributes: .concurrent)
    
    var imageModels = [
            ImageModel(url: URL(string: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg")!),
            ImageModel(url: URL(string: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg")!),
            ImageModel(url: URL(string: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg")!),
            ImageModel(url: URL(string: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg")!),
            ImageModel(url: URL(string: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg")!),
            ImageModel(url: URL(string: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg")!),
            ImageModel(url: URL(string: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg")!),
            ImageModel(url: URL(string: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg")!)
        ]
    
    func downloadImageData() {
        
        for imgmodel in imageModels {
            semaphore.wait()
            
            downloadQueue.async {
                Task {
                    do {
                        if let imgData = try? await self.apiService.downloadImage(from: imgmodel.url) {
                            self.imgData.append(imgData)
                            self.semaphore.signal()
                        }
                    }
                }
            }
        }
    }
}
