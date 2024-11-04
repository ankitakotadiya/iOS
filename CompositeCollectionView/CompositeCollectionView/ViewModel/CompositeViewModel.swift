//
//  CompositeViewModel.swift
//  CompositeCollectionView
//
//  Created by Ankita Kotadiya on 03/11/24.
//

import Foundation
import Combine

enum ProductCategory: String {
    case beauty = "beauty"
    case fragrances = "fragrances"
    case furniture = "furniture"
    case grocery = "groceries"
}

class CompositeViewModel {
    let networkManager: NetworkManaging
    
    struct Section {
        let title: ProductCategory
        let products: [Product]
    }
    
    @Published var sections: [Section] = []
        
    init(networkManager: NetworkManaging = DependencyManager.networkManager) {
        self.networkManager = networkManager
    }
    
    func load() async {
        let results = await networkManager.fetchData(Product.productList)
        
        switch results {
        case .success(let page):
            self.filterData(page.products)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func filterData(_ products: [Product]) {
        let beauty = products.filter({$0.category == ProductCategory.beauty.rawValue})
        let furniture = products.filter({$0.category == ProductCategory.furniture.rawValue})
        let fragrances = products.filter({$0.category == ProductCategory.fragrances.rawValue})
        let grocery = products.filter({$0.category == ProductCategory.grocery.rawValue})
        
        sections = [
            Section(title: .beauty, products: beauty),
            Section(title: .fragrances, products: fragrances),
            Section(title: .furniture, products: furniture),
            Section(title: .grocery, products: grocery)
        ]
    }
}
