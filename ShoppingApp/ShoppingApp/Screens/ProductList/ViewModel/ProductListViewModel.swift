//
//  ProductListViewModel.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
//

import Foundation
import Combine

enum ProductListState {
    case loading
    case loaded([Product])
    case eror(String)
    
    var products: [Product] {
        switch self {
        case .loaded(let products):
            return products
            
        case .loading, .eror(_):
            return []
        }
    }
}

final class ProductListViewModel {
    let networkManager: NetworkManaging
    @Published var state: ProductListState = .loading
    private var mainProduct: [Product] = []
    var filters: [Filter] = []
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getProductList() {
        networkManager.execute(Product.productList) { [weak self] response in
            guard let self = self else {return}
            switch response {
            case .success(let page):
                self.state = .loaded(page.products)
                self.mainProduct = page.products
            case .failure(let error):
                self.state = .eror(error.localizedDescription)
            }
        }
    }
    
    func filterProducts(filters: [Filter]) {
        self.filters = filters
        var filteredProducts = mainProduct

        for filter in filters {
            let subFilterIDs = Set(filter.values.map({ $0.id }))
            
            switch filter.title {
            case .date:
                filteredProducts = filteredProducts.filter { product in
                    guard let date = product.createdAt else { return false }
                    return subFilterIDs.contains(date)
                }
            case .brand:
                filteredProducts = filteredProducts.filter { product in
                    guard let brand = product.brand else { return false }
                    return subFilterIDs.contains(brand)
                }
            case .category:
                filteredProducts = filteredProducts.filter { product in
                    subFilterIDs.contains(product.category)
                }
            case .price:
                // Implement if needed
                break
            }
        }
        
        self.state = .loaded(filteredProducts)
    }
}
